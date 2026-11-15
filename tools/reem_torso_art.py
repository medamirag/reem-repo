"""Clean source-derived sleeves/accessories and build a closed outlined native tunic."""
import math
from pathlib import Path
from PIL import Image, ImageChops, ImageFilter, ImageDraw

def refined_textures(root, source):
    dest=root/'game/characters/reem/refined';dest.mkdir(exist_ok=True)
    w,h=source.size;pixels=source.load();pending=bytearray(w*h)
    for y in range(400,900):
        for x in range(400,800):
            r,g,b,a=pixels[x,y]
            if a>160 and r>55 and g>25 and r>g*1.15 and b<g*.62:
                pending[y*w+x]=1
    seed=Image.new('L',source.size);sp=seed.load()
    for n in range(len(pending)):
        if not pending[n]:continue
        pending[n]=0;todo=[n];component=[]
        while todo:
            k=todo.pop();component.append(k)
            for q in (k-1,k+1,k-w,k+w):
                if 0<=q<len(pending) and pending[q]:pending[q]=0;todo.append(q)
        if len(component)>200:
            for k in component:sp[k%w,k//w]=255
    support=seed.filter(ImageFilter.MaxFilter(17)).load()
    closed=seed.filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.MinFilter(5))
    flooded=closed.copy();ImageDraw.floodfill(flooded,(0,0),128)
    holes=flooded.point(lambda value:255 if value==0 else 0).load()
    mask=Image.new('L',source.size);mp=mask.load()
    for y in range(400,900):
        for x in range(400,800):
            r,g,b,a=pixels[x,y]
            if y>690 and x<492:continue
            if a and (sp[x,y] or holes[x,y] or (support[x,y] and (max(r,g,b)<110 or (r>60 and r>g*1.1 and b<g*.75)))):
                mp[x,y]=255
    accessories=Image.new('RGBA',source.size);accessories.paste(source,(0,0),mask)
    accessories.save(dest/'bag_and_strap.png')
    inverse=ImageChops.invert(mask)
    for side in ['front','back']:
        layer=Image.open(root/f'game/characters/reem/aligned/arm_{side}.png').convert('RGBA')
        alpha=ImageChops.multiply(layer.getchannel('A'),inverse)
        solid=alpha.point(lambda a:255 if a>=128 else 0)
        clean=solid.filter(ImageFilter.MinFilter(5)).filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.MaxFilter(3))
        cleaned=ImageChops.multiply(alpha,clean)
        alpha.paste(cleaned.crop((390,390,850,650)),(390,390))
        # Repaint the unoutlined shoulder overlap, including the source's grey
        # fringe. Keep the black outer sleeve outline and all hand pixels.
        layer.putalpha(alpha)
        lp=layer.load()
        for y in range(430,600):
            fade=1-smooth(550,600,y)
            for x in range(480,590):
                r,g,b,a=lp[x,y]
                if a and ((y<550 and g>35 and b>25) or (g>70 and b>70 and r<g*.65) or a<220):
                    lp[x,y]=(37,174,168,255) if a<220 else (round(r*(1-fade)+37*fade),round(g*(1-fade)+174*fade),round(b*(1-fade)+168*fade),255)
        if side=='front':
            # One smooth outlined sleeve edge, replacing the old 10px jump
            # at y530/540. The lower sleeve/hand and joint weights are unchanged.
            edge=curve((552,465),(540,490),(500,550),(476,600),135)
            for y in range(465,601):
                left=next((a[0]+(b[0]-a[0])*(y-a[1])/(b[1]-a[1]) for a,b in zip(edge,edge[1:]) if a[1]<=y<=b[1]),476)
                old=[x for x in range(390,600) if lp[x,y][3]>128]
                start=min(min(old)-3 if old else int(left)-3,int(left)-3)
                sample=lp[min(620,int(left)+25),y]
                fabric=sample[:3] if sample[1]>120 and sample[2]>100 else (37,174,168)
                for x in range(start,int(left)+22):
                    distance=x+.5-left
                    if distance<-.5:lp[x,y]=(0,0,0,0);continue
                    if distance<6.5:rgb=(6,5,3)
                    else:
                        blend=smooth(6.5,8,distance)
                        rgb=tuple(round((6,5,3)[k]*(1-blend)+fabric[k]*blend) for k in range(3))
                    lp[x,y]=(*rgb,round(255*max(0,min(1,distance+.5))))
        layer.save(dest/f'arm_{side}.png')
    print('[TORSO] cleaned source sleeve fragments and extracted original bag/strap')

def curve(a,b,c,d,steps=24):
    return [tuple(round((1-t)**3*a[k]+3*(1-t)**2*t*b[k]+3*(1-t)*t*t*c[k]+t**3*d[k],5) for k in (0,1)) for t in [i/steps for i in range(steps+1)]]

def outline():
    segments=[((565,435),(537,448),(500,520),(510,570)),
              ((510,570),(522,635),(520,720),(501,810)),
              ((501,810),(488,872),(467,930),(459,953)),
              ((459,953),(456,966),(536,992),(620,992)),
              ((620,992),(695,992),(783,966),(778,953)),
              ((778,953),(756,889),(739,704),(735,610)),
              ((735,610),(731,548),(730,493),(695,465)),
              ((695,465),(665,438),(602,420),(565,435))]
    points=[]
    for segment in segments:points+=curve(*segment)[:-1]
    return points

def inset(points,width):
    area=sum(p[0]*q[1]-q[0]*p[1] for p,q in zip(points,points[1:]+points[:1]))
    result=[]
    for i,p in enumerate(points):
        before=points[i-1];after=points[(i+1)%len(points)]
        dx=after[0]-before[0];dy=after[1]-before[1];length=math.hypot(dx,dy)
        sign=1 if area>0 else -1
        result.append((round(p[0]-sign*dy/length*width,5),round(p[1]+sign*dx/length*width,5)))
    # Tight hem turns can make a normal-offset contour loop over itself. Cut
    # those tiny interior loops at their intersection; the visible outer curve
    # stays unchanged and the fill remains a simple triangulatable polygon.
    def cross(a,b,c):return (b[0]-a[0])*(c[1]-a[1])-(b[1]-a[1])*(c[0]-a[0])
    for iteration in range(100):
        hit=None
        for i,a in enumerate(result):
            b=result[(i+1)%len(result)]
            for j in range(i+2,len(result)):
                if i==0 and j==len(result)-1:continue
                c=result[j];d=result[(j+1)%len(result)]
                if cross(a,b,c)*cross(a,b,d)<0 and cross(c,d,a)*cross(c,d,b)<0:
                    dx=b[0]-a[0];dy=b[1]-a[1];ex=d[0]-c[0];ey=d[1]-c[1]
                    t=((c[0]-a[0])*ey-(c[1]-a[1])*ex)/(dx*ey-dy*ex)
                    hit=(i,j,(round(a[0]+t*dx,5),round(a[1]+t*dy,5)));break
            if hit:break
        if not hit:return result
        i,j,point=hit;result=result[:i+1]+[point]+result[j+1:]
    raise ValueError('Torso inset contour still intersects itself')

def smooth(a,b,t):
    t=max(0,min(1,(t-a)/(b-a)));return t*t*(3-2*t)

def add_torso(lines,data):
    outer=outline()
    for name,points,tint in [('TorsoOutline',outer,(.025,.020,.012)),('TorsoFabric',inset(outer,7),(1,1,1))]:
        hem=[round(smooth(790,980,p[1]),7) for p in points]
        lines.extend([f'[node name="{name}" type="Polygon2D" parent="Skeleton2D"]',
          'polygon = PackedVector2Array('+', '.join(str(p[i]-data['feet_origin'][i]) for p in points for i in (0,1))+')',
          'uv = PackedVector2Array('+', '.join(str(v) for p in points for v in p)+')',
          'color = Color('+', '.join(map(str,tint))+', 1)',
          'antialiased = true','skeleton = NodePath("..")',
          'metadata/redrawn_torso = true','metadata/outline_width = 7.0',
          'metadata/skin = {"Body": PackedFloat32Array('+', '.join(str(round(1-v,7)) for v in hem)+'), "Body/Hem": PackedFloat32Array('+', '.join(map(str,hem))+')}'])
        if name=='TorsoFabric':lines+=['texture = ExtResource("source")','material = SubResource("TorsoFabric")']
    print('[TORSO] created rounded closed silhouette with continuous 7px outline')
