"""Source-preserving cutouts and native face overlays. No runtime animation."""
from pathlib import Path
import json,math,sys
from collections import deque
from PIL import Image,ImageDraw,ImageChops,ImageFilter,ImageFont
ROOT=Path(__file__).resolve().parents[1]
MAN=ROOT/'docs/rigs/character_manifest.json'
# All feature boxes are measured in the unflipped source image, never room coordinates.
FACES={
'grandpa':([[.438,.125,.516,.181],[.553,.118,.609,.169]],[.475,.195,.644,.267]),
'jad':([[.438,.125,.516,.181],[.553,.118,.609,.169]],[.475,.195,.644,.267]),
'fox':([[.525,.199,.621,.311]],[.547,.309,.65,.354]),
'bees':([[.635,.335,.785,.588],[.826,.337,.926,.572]],[.78,.59,.9,.66]),
'arnoob':([[.516,.344,.58,.431]],[.55,.429,.626,.505]),
'sinjoob':([[.759,.193,.872,.297]],[.845,.297,.923,.354]),
'qunfood':([[.652,.284,.726,.39]],[.706,.395,.813,.45]),
'qatqoota':([[.655,.248,.752,.37]],[.73,.367,.795,.416]),
'ghazlana':([[.634,.198,.739,.278]],[.743,.294,.81,.327]),
'dubb':([[.585,.178,.638,.255]],[.648,.286,.719,.327]),
'dafdoof':([[.497,.062,.654,.245]],[.611,.23,.79,.343]),
'tawoos':([[.674,.15,.746,.219]],[.75,.203,.86,.23]),
'qarqoor':([[.272,.171,.335,.263],[.36,.205,.474,.30]],[.275,.305,.411,.35]),
'ankoob':([[.344,.646,.467,.785],[.518,.646,.65,.784]],[.42,.754,.57,.855]),
'duck':([[.69,.125,.801,.237]],[.777,.245,.968,.299]),
}
for i in range(1,4):FACES[f'duckling{i}']=([ [.632,.166,.765,.293] ],[.75,.289,.945,.396])
EXTRAS={
'arnoob':[[.395,.0],[.56,.0],[.579,.3],[.43,.34]],
'sinjoob':[[.0,.15],[.43,.11],[.55,.34],[.4,.68],[.48,.79],[.3,.85],[.1,.76]],
'qunfood':[[.446,.145],[.584,.15],[.585,.3],[.449,.306]],
'qatqoota':[[.22,.78],[.39,.78],[.51,.91],[.29,.95],[.2,.88]],
'ghazlana':[[.02,.48],[.16,.46],[.22,.55],[.13,.64],[.015,.60]],
'dubb':[[.32,.033],[.49,.04],[.49,.2],[.32,.2]],
'tawoos':[[.08,.78],[.17,.59],[.43,.45],[.58,.43],[.61,.6],[.45,.8],[.12,.9]],
'qarqoor':[[.66,.38],[.85,.3],[.98,.36],[.94,.49],[.78,.47],[.82,.57],[.76,.63],[.66,.64]],
'duck':[[.0,.47],[.16,.48],[.28,.58],[.2,.76],[.0,.69]],
}
for i in range(1,4):EXTRAS[f'duckling{i}']=[[.0,.43],[.17,.48],[.28,.56],[.2,.70],[.03,.66]]
FULL={
'fox':dict(root=[627,1254],head=[640,465],polys={
 'tail':[[230,580],[425,570],[470,770],[550,840],[550,945],[400,1000],[250,920]],
 'upper_leg_far':[[659,848],[737,850],[743,1030],[646,1040]],
 'lower_leg_far':[[646,1000],[744,1000],[750,1176],[633,1176]],
 'foot_far':[[620,1143],[820,1136],[861,1245],[620,1245]],
 'upper_leg_near':[[552,848],[654,870],[603,1044],[506,1040]],
 'lower_leg_near':[[507,1000],[603,1000],[577,1180],[466,1180]],
 'foot_near':[[413,1145],[580,1136],[610,1245],[410,1245]],
 'upper_arm_far':[[718,628],[770,653],[811,758],[758,799],[715,724]],
 'lower_arm_far':[[755,747],[811,735],[855,815],[799,849]],
 'hand_far':[[790,774],[870,787],[891,872],[792,890],[768,831]],
 'upper_arm_near':[[598,554],[661,592],[584,718],[509,711]],
 'lower_arm_near':[[516,681],[598,693],[532,802],[444,794]],
 'hand_near':[[455,759],[531,791],[544,837],[497,887],[430,879],[416,818]],
 'head_blank':[[422,0],[896,0],[910,470],[735,492],[692,504],[615,492],[421,444]],
 'ear_far':[[625,40],[720,40],[757,200],[635,220]],
 'ear_near':[[465,0],[590,0],[665,165],[570,315],[465,315]],
 },joints={'upper_arm_near':[617,584],'lower_arm_near':[552,704],'hand_near':[493,787],'upper_arm_far':[735,654],'lower_arm_far':[780,759],'hand_far':[816,803],'upper_leg_near':[595,881],'lower_leg_near':[551,1018],'foot_near':[521,1166],'upper_leg_far':[694,883],'lower_leg_far':[689,1017],'foot_far':[691,1171],'tail':[538,891],'ear_near':[570,252],'ear_far':[685,174]}),
'grandpa':dict(root=[302,982],head=[247,280],polys={
 'seat_and_stool':[[0,420],[134,420],[130,638],[286,640],[275,875],[203,928],[0,960]],
 'cane':[[102,505],[175,507],[150,650],[130,982],[76,982],[96,627]],
 'lower_leg_far':[[408,725],[497,720],[532,828],[437,866],[399,801]],
 'foot_far':[[428,807],[566,787],[604,885],[436,893]],
 'lower_leg_near':[[272,809],[364,793],[380,927],[264,937]],
 'foot_near':[[260,882],[353,883],[424,947],[398,982],[250,982]],
 'upper_arm_far':[[315,324],[356,331],[411,420],[440,498],[388,521],[356,438]],
 'lower_arm_far':[[387,460],[433,462],[466,526],[408,548],[381,508]],
 'hand_far':[[405,503],[466,505],[508,542],[507,575],[451,585],[400,559]],
 'upper_arm_near':[[130,319],[188,315],[236,369],[242,465],[174,489],[125,448]],
 'lower_arm_near':[[172,450],[239,451],[300,495],[283,567],[235,588],[145,535]],
 'head_blank':[[106,0],[413,0],[423,259],[359,314],[235,308],[107,264]],
 },joints={'upper_arm_near':[161,344],'lower_arm_near':[200,470],'hand_near':[275,526],'upper_arm_far':[331,355],'lower_arm_far':[401,481],'hand_far':[437,540],'upper_leg_near':[290,629],'lower_leg_near':[306,785],'foot_near':[313,902],'upper_leg_far':[353,619],'lower_leg_far':[431,743],'foot_far':[467,819],'cane':[126,539]})}

REFERENCES={
'grandpa':((.52,.182),(.56,.29)),'jad':((.52,.182),(.56,.29)),
'fox':((.516,.27),(.592,.366)),'bees':((.79,.56),(.78,.65)),
'arnoob':((.50,.385),(.52,.445)),'sinjoob':((.745,.25),(.83,.37)),
'qunfood':((.63,.34),(.69,.46)),'qatqoota':((.62,.31),(.69,.40)),
'ghazlana':((.60,.24),(.72,.325)),'dubb':((.55,.23),(.655,.35)),
'dafdoof':((.675,.19),(.65,.22)),'tawoos':((.68,.21),(.8,.20)),
'qarqoor':((.49,.31),(.42,.35)),'ankoob':((.48,.67),(.4,.82)),
'duck':((.66,.20),(.9,.22))}
for i in range(1,4):REFERENCES[f'duckling{i}']=((.61,.24),(.88,.26))
CURRENT_NAME=''

def mask_polygon(size,points):
 scale=4;im=Image.new('L',(size[0]*scale,size[1]*scale));ImageDraw.Draw(im).polygon([(round(x*scale),round(y*scale)) for x,y in points],fill=255);return im.resize(size,Image.Resampling.LANCZOS)
def cut(source,mask):
 im=source.copy();im.putalpha(ImageChops.multiply(source.getchannel('A'),mask));return im
def pixels_box(box,size):return tuple(round(v*size[i%2]) for i,v in enumerate(box))
def source_patch(source,box):
 out=Image.new('RGBA',source.size);out.paste(source.crop(box),box[:2]);out.putalpha(out.getchannel('A').point(lambda a:255 if a>250 else 0));return out
def overlay(source,box,kind):
 # Retain the source perimeter. Only the feature interior gets a native lid/mouth.
 w,h=source.size;x0,y0,x1,y1=box;bw=x1-x0;bh=y1-y0
 region=source.crop(box).resize((bw*4,bh*4),Image.Resampling.LANCZOS)
 pix=source.load();cx=(x0+x1)//2;cy=(y0+y1)//2
 samples=[pix[max(0,x0-4),cy],pix[min(w-1,x1+4),cy],pix[cx,max(0,y0-4)],pix[cx,min(h-1,y1+4)]]
 candidates=[c for c in samples if c[3]>220 and max(c[:3])>90]
 colour=tuple(sorted(c[k] for c in candidates)[len(candidates)//2] for k in range(3)) if candidates else (238,190,120)
 draw=ImageDraw.Draw(region);W,H=region.size
 # Reconstruct only the feature pixels, not a rectangular patch of fur.
 reference=REFERENCES[CURRENT_NAME][0 if kind in ['eyes_closed','blank_eye'] else 1]
 ref=pix[min(w-1,round(reference[0]*w)),min(h-1,round(reference[1]*h))][:3]
 valid=lambda c: c[3]>200 and sum((c[k]-ref[k])**2 for k in range(3))<80**2
 rim=[c for c in samples if valid(c)]
 if max(ref)<50:ref=colour
 fill=Image.new('RGBA',(bw,bh));pixels=fill.load();candidate=bytearray(bw*bh)
 for yy in range(bh):
  for xx in range(bw):
   c=pix[x0+xx,y0+yy]
   candidate[yy*bw+xx]=1 if sum((c[k]-ref[k])**2 for k in range(3))>55**2 else 0
   boundary=[pix[max(0,x0-2),y0+yy],pix[min(w-1,x1+1),y0+yy],pix[x0+xx,max(0,y0-2)],pix[x0+xx,min(h-1,y1+1)]]
   boundary=[c if valid(c) else (*ref,255) for c in boundary]
   weights=[1/(xx+1)**2,1/(bw-xx)**2,1/(yy+1)**2,1/(bh-yy)**2]
   pixels[xx,yy]=tuple(round(sum(c[k]*weight for c,weight in zip(boundary,weights))/sum(weights)) for k in range(3))+(255,)
 todo=deque();seen=bytearray(bw*bh)
 for yy in range(max(0,int(bh*.15)),min(bh,int(bh*.85))):
  for xx in range(max(0,int(bw*.15)),min(bw,int(bw*.85))):
   at=yy*bw+xx
   if candidate[at]:seen[at]=1;todo.append(at)
 while todo:
  at=todo.popleft();xx=at%bw;yy=at//bw
  for nx,ny in [(xx-1,yy),(xx+1,yy),(xx,yy-1),(xx,yy+1)]:
   if 0<=nx<bw and 0<=ny<bh:
    n=ny*bw+nx
    if candidate[n] and not seen[n]:seen[n]=1;todo.append(n)
 feature=Image.frombytes('L',(bw,bh),bytes(255 if v else 0 for v in seen))
 if kind.startswith('mouth_') or kind=='blank_mouth':
  fm=feature.load()
  for yy in range(bh):
   for xx in range(bw):
    r,g,b,a=pix[x0+xx,y0+yy]
    if not (max(r,g,b)<140 or (r>130 and r>g*1.35 and g<170 and b>60)):fm[xx,yy]=0
 if CURRENT_NAME=='fox' and kind in ['eyes_closed','blank_eye']:
  eye=Image.new('L',(bw,bh));ImageDraw.Draw(eye).ellipse((.541*w-x0,.232*h-y0,.616*w-x0,.303*h-y0),fill=255)
  ep=eye.load()
  for yy in range(bh):
   for xx in range(bw):
    if max(pix[x0+xx,y0+yy][:3])<140:ep[xx,yy]=255
  feature=eye
 feature=feature.filter(ImageFilter.MaxFilter(9))
 fill=fill.filter(ImageFilter.GaussianBlur(3.0))
 # Retain the original external silhouette/outline, even where a mouth joins it.
 protect=source.getchannel('A').crop((x0-6,y0-6,x1+6,y1+6)).filter(ImageFilter.MinFilter(13)).crop((6,6,bw+6,bh+6)).point(lambda a:255 if a>250 else 0)
 feature=ImageChops.multiply(feature,protect).filter(ImageFilter.GaussianBlur(1.2))
 original=source.crop(box);clean=Image.composite(fill,original,feature)
 region=clean.resize((W,H),Image.Resampling.LANCZOS);draw=ImageDraw.Draw(region)
 ink=(22,12,6,255);line=max(5,round(w/180)*4)
 if kind=='eyes_closed':
  pts=[(int(W*(.12+.76*i/24)),int(H*(.44+.18*math.sin(math.pi*i/24)))) for i in range(25)];draw.line(pts,fill=ink,width=line,joint='curve')
 elif kind=='mouth_open':
  draw.ellipse((W*.17,H*.16,W*.85,H*.87),fill=ink);draw.ellipse((W*.31,H*.63,W*.72,H*.86),fill=(205,105,91,255))
 elif kind in ['mouth_closed','mouth_smile','mouth_sad','mouth_surprised']:
  if kind=='mouth_surprised':draw.ellipse((W*.38,H*.16,W*.66,H*.85),fill=ink)
  else:
   sign=-1 if kind=='mouth_sad' else 1
   pts=[(int(W*(.12+.76*i/24)),int(H*(.50+sign*.15*math.sin(math.pi*i/24)))) for i in range(25)];draw.line(pts,fill=ink,width=line,joint='curve')
 result=Image.new('RGBA',source.size);result.paste(region.resize((bw,bh),Image.Resampling.LANCZOS),box[:2]);result.putalpha(ImageChops.multiply(result.getchannel('A'),source.getchannel('A')).point(lambda a:255 if a>250 else 0));return result

def main():
 global CURRENT_NAME
 only=set(sys.argv[1].split(',')) if len(sys.argv)>1 else set()
 data=json.loads(MAN.read_text());font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',18)
 for c in data:
  if c['tier']=='code_only' or (only and c['name'] not in only):continue
  name=c['name'];CURRENT_NAME=name;source=Image.open(ROOT/c['current_sprite']).convert('RGBA');size=source.size;c['canvas']=list(size);folder=ROOT/f'game/rig_parts/{name}';folder.mkdir(parents=True,exist_ok=True)
  eyes,mouth=FACES[name];eyes=[pixels_box(b,size) for b in eyes];mouth=pixels_box(mouth,size);parts={};meta=dict(source=c['current_sprite'],canvas=list(size),eyes=eyes,mouth=mouth,features_anchor=[sum((b[0]+b[2])/2 for b in eyes)/len(eyes),sum((b[1]+b[3])/2 for b in eyes)/len(eyes)],mouth_anchor=[(mouth[0]+mouth[2])/2,(mouth[1]+mouth[3])/2])
  if c['tier']=='full':
   cfg=FULL[name];masks={};remaining=source.getchannel('A').point(lambda a:255 if a else 0)
   # Ordered partition: the visible colour of every pixel comes from the source.
   for part,points in reversed(list(cfg['polys'].items())):
    mask=ImageChops.multiply(mask_polygon(size,points).point(lambda v:255 if v>=128 else 0),remaining);masks[part]=mask;remaining=ImageChops.subtract(remaining,mask)
   masks['torso']=remaining
   if name=='grandpa':
    stool=mask_polygon(size,[[428,847],[604,840],[604,982],[421,982]]).point(lambda v:255 if v>128 else 0);masks['seat_and_stool']=ImageChops.lighter(masks['seat_and_stool'],stool);
    for owned in list(masks):
     if owned!='seat_and_stool':masks[owned]=ImageChops.subtract(masks[owned],stool)
   body_points=([[192,277],[275,278],[355,315],[401,480],[505,568],[554,736],[444,792],[283,854],[136,730],[104,654],[106,395],[131,320]] if name=='grandpa' else [[609,477],[698,479],[745,546],[755,704],[715,861],[656,920],[549,911],[577,742],[574,601]])
   body_shape=mask_polygon(size,body_points).point(lambda v:255 if v>128 else 0)
   residue=ImageChops.subtract(masks['torso'],body_shape)
   masks['torso']=ImageChops.multiply(masks['torso'],body_shape)
   rp=residue.load();targets={k:v.load() for k,v in masks.items()}
   for yy in range(size[1]):
    for xx in range(size[0]):
     if not rp[xx,yy]:continue
     if name=='grandpa':key='seat_and_stool'
     elif yy<510:key='head_blank'
     elif yy>=900:key=('foot_' if yy>=1135 else 'lower_leg_' if yy>1000 else 'upper_leg_')+('near' if xx<635 else 'far')
     elif xx<575:key='tail' if xx<460 or yy>890 else 'upper_arm_near' if yy<700 else 'lower_arm_near' if yy<790 else 'hand_near'
     elif xx>750:key='upper_arm_far' if yy<750 else 'lower_arm_far' if yy<800 else 'hand_far'
     else:key='torso'
     targets[key][xx,yy]=255
   # Jacket/scarf pixels belong to the single trunk, never to a swinging arm.
   garment=Image.new('L',size);gp=garment.load();sp=source.load()
   for yy in range(size[1]):
    for xx in range(size[0]):
     r,g,b,a=sp[xx,yy]
     if a>220 and ((name=='grandpa' and g>55 and g>r*.90 and b<g*.70) or (name=='fox' and r>50 and b>r*.8 and b>g*1.3 and g<140)):gp[xx,yy]=255
   border=garment.filter(ImageFilter.MaxFilter(5));bp=border.load()
   for yy in range(size[1]):
    for xx in range(size[0]):
     r,g,b,a=sp[xx,yy]
     if gp[xx,yy] or (bp[xx,yy] and max(r,g,b)<65 and a>0):
      for key,owned in targets.items():owned[xx,yy]=255 if key=='torso' else 0
   order=['seat_and_stool','tail','upper_leg_far','lower_leg_far','foot_far','upper_leg_near','lower_leg_near','foot_near','cane','torso','upper_arm_far','lower_arm_far','hand_far','upper_arm_near','lower_arm_near','hand_near','head_blank','ear_far','ear_near']
   for p in c['parts']:
    part=p['name']
    if part in masks:parts[part]=cut(source,masks[part])
   # Fully concealed upper thighs / near hand in the approved seated sprite.
   if name=='grandpa':
    for part in ['upper_leg_far','upper_leg_near','hand_near']:
     parts[part]=Image.new('RGBA',size)
   # Reconstruct the trunk hidden by limbs. Preserve every visible source pixel.
   body_points=([[192,277],[275,278],[355,315],[401,480],[505,568],[554,736],[444,792],[283,854],[136,730],[104,654],[106,395],[131,320]] if name=='grandpa' else [[609,477],[698,479],[745,546],[755,704],[715,861],[656,920],[549,911],[577,742],[574,601]])
   body_shape=mask_polygon(size,body_points)
   occlusion=Image.new('L',size)
   for part,mask in masks.items():
    if part.startswith(('upper_arm','lower_arm','hand','head')):occlusion=ImageChops.lighter(occlusion,mask)
   hidden_body=ImageChops.multiply(ImageChops.multiply(body_shape,occlusion),source.getchannel('A').point(lambda a:255 if a>250 else 0))
   fill=Image.new('RGBA',size)
   fp=fill.load();hm=hidden_body.load()
   for yy in range(size[1]):
    for xx in range(size[0]):
     if not hm[xx,yy]:continue
     if name=='grandpa':
      rgb=(102,111,31) if xx<220 and yy<650 else (232-round(25*yy/size[1]),197-round(26*yy/size[1]),130-round(25*yy/size[1]))
     else:rgb=(251,138,26) if xx<657 else (255,239,213)
     fp[xx,yy]=(*rgb,hm[xx,yy])
   fill.alpha_composite(parts['torso']);parts['torso']=fill
   if name=='grandpa':
    for part,other in [('upper_leg_near','lower_leg_near'),('upper_leg_far','lower_leg_far')]:
     capsule=Image.new('RGBA',size);d=ImageDraw.Draw(capsule);a=cfg['joints'][part];b=cfg['joints'][other];r=28
     d.line([tuple(a),tuple(b)],fill=(15,9,3,255),width=r*2)
     for at in [a,b]:d.ellipse((at[0]-r,at[1]-r,at[0]+r,at[1]+r),fill=(15,9,3,255))
     d.line([tuple(a),tuple(b)],fill=(224,186,113,255),width=r*2-10)
     for at in [a,b]:d.ellipse((at[0]-r+5,at[1]-r+5,at[0]+r-5,at[1]+r-5),fill=(224,186,113,255))
     covered=Image.new('L',size)
     for later in order[order.index(part)+1:]:
      if later in masks:covered=ImageChops.lighter(covered,masks[later])
     capsule.putalpha(ImageChops.multiply(ImageChops.multiply(capsule.getchannel('A'),covered),source.getchannel('A').point(lambda a:255 if a>250 else 0)));parts[part]=capsule
   original_head=parts['head_blank'].copy()
   for b in eyes+[mouth]:
    blank=overlay(source,b,'blank_mouth' if b==mouth else 'blank_eye');core=original_head.getchannel('A').crop(b).point(lambda a:255 if a>250 else 0);patch=Image.composite(blank.crop(b),parts['head_blank'].crop(b),core);parts['head_blank'].paste(patch,b[:2])
   # Only hidden joint caps are painted; later source pieces cover them at rest.
   for part,at in cfg['joints'].items():
    if part not in parts:continue
    index=order.index(part);cover=Image.new('L',size)
    for other in order[index+1:]:
     if other in masks:cover=ImageChops.lighter(cover,masks[other])
    r=28 if name=='grandpa' else 35;ellipse=Image.new('L',size);ImageDraw.Draw(ellipse).ellipse((at[0]-r,at[1]-r,at[0]+r,at[1]+r),fill=255)
    hidden=ImageChops.multiply(ImageChops.multiply(ellipse,cover),source.getchannel('A').point(lambda a:255 if a>250 else 0)).point(lambda a:255 if a>250 else 0)
    colour=(224,186,113,255) if name=='grandpa' else (244,131,28,255)
    if 'hand' in part:colour=(245,173,91,255) if name=='grandpa' else (100,52,34,255)
    cap=Image.new('RGBA',size,colour);ImageDraw.Draw(cap).ellipse((at[0]-r,at[1]-r,at[0]+r,at[1]+r),outline=(12,8,4,255),width=5 if name=='grandpa' else 7);cap.putalpha(hidden);cap.alpha_composite(parts[part]);parts[part]=cap
   parts['eyes_open']=Image.new('RGBA',size)
   for box in eyes:parts['eyes_open'].alpha_composite(source_patch(original_head,box))
   # Exact original mouth is the full rig's neutral smile. Other variants cover it.
   parts['mouth_smile']=source_patch(original_head,mouth)
   meta.update(root=cfg['root'],head_pivot=cfg['head'],joints=cfg['joints'],draw_order=[p for p in order if p in parts]+['eyes_open','mouth_smile'])
  if name=='grandpa':
   hand=Image.new('RGBA',size);hand.alpha_composite(parts['hand_far'],(-162,-14));parts['hand_near']=hand
   meta['neutral_hidden']=['hand_near'];meta['draw_order']=[p for p in meta['draw_order'] if p!='hand_near']
  for feature in ['eyes_closed','mouth_open','mouth_closed']+(['mouth_sad','mouth_surprised'] if c['tier']=='full' else []):
   parts[feature]=Image.new('RGBA',size)
   for b in eyes if feature=='eyes_closed' else [mouth]:parts[feature].alpha_composite(source_patch(source,b) if (feature=='mouth_open' and name in ['dafdoof','duck','duckling1','duckling2','duckling3','ankoob']) or (feature=='mouth_closed' and name not in ['dafdoof','duck','duckling1','duckling2','duckling3','ankoob','arnoob']) else overlay(source,b,feature))
  if name=='duck' or name.startswith('duckling'):
   if name=='duck':
    upper=[[.765,.257],[.798,.213],[.956,.182],[.995,.19],[.999,.215],[.985,.247],[.94,.274],[.858,.289],[.794,.276]]
    erase=[[.765,.255],[.805,.2],[.98,.18],[1,.19],[1,.26],[.96,.3],[.91,.35],[.84,.345],[.78,.308]]
   else:
    upper=[[.752,.287],[.807,.242],[.955,.227],[.997,.241],[.997,.276],[.971,.309],[.90,.337],[.833,.35],[.77,.326]]
    erase=[[.749,.286],[.81,.232],[.96,.222],[1,.23],[1,.29],[.97,.35],[.93,.41],[.84,.423],[.75,.355]]
   points=[(x*size[0],y*size[1]) for x,y in upper]
   upper_bill=cut(source,mask_polygon(size,points))
   # The open lower bill concealed this small feathered jaw surface. Restore it
   # as part of the closed-mouth overlay, keeping the original upper bill pixels.
   start,control,end=([.835,.285],[.84,.335],[.765,.39]) if name=='duck' else ([.80,.33],[.815,.377],[.70,.425])
   curve_points=[]
   for i in range(33):
    t=i/32;curve_points.append(((1-t)**2*start[0]+2*(1-t)*t*control[0]+t*t*end[0],(1-t)**2*start[1]+2*(1-t)*t*control[1]+t*t*end[1]))
   left=[[.745,.265],[.755,.27]] if name=='duck' else [[.70,.30],[.75,.30]]
   poly=left+curve_points+([[.72,.35]] if name=='duck' else [[.655,.365]])
   jaw=Image.new('RGBA',size)
   ref=(.72,.31) if name=='duck' else (.68,.365)
   colour=source.getpixel((round(ref[0]*size[0]),round(ref[1]*size[1])))[:3]
   jaw.paste((*colour,255),(0,0,size[0],size[1]));jaw.putalpha(mask_polygon(size,[(x*size[0],y*size[1]) for x,y in poly]))
   ImageDraw.Draw(jaw).line([(round(x*size[0]),round(y*size[1])) for x,y in curve_points],fill=(35,17,5,255),width=max(3,round(size[0]/230)),joint='curve')
   jaw.alpha_composite(upper_bill);parts['mouth_closed']=jaw
   meta['erase_masks']={'mouth_closed':[[round(x*size[0]),round(y*size[1])] for x,y in erase]}
   mask=mask_polygon(size,[(x*size[0],y*size[1]) for x,y in erase]).point(lambda a:255 if a>128 else 0)
   skin=Image.new('L',size);sk=skin.load();sp=source.load()
   for yy in range(size[1]):
    for xx in range(size[0]):
     r,g,b,a=sp[xx,yy]
     if a>200 and g>r*.72 and b>55:sk[xx,yy]=255
   mask=ImageChops.subtract(mask,skin.filter(ImageFilter.MaxFilter(7)))
   runs=[];mp=mask.load()
   for yy in range(size[1]):
    start=None
    for xx in range(size[0]+1):
     on=xx<size[0] and mp[xx,yy]>128
     if on and start is None:start=xx
     elif not on and start is not None:runs.append([yy,start,xx]);start=None
   meta['erase_runs']={'mouth_closed':runs}  # exact source mask; no extra image file

   meta['mouth_closed_note']='Mask the original open bill with this polygon on the unchanged base sprite, then overlay the source-cut upper bill. Reset mask for open state.'
  for extra in ['tail','ears']:
   if c['tier']=='light' and any(p['name']==extra for p in c['parts']):parts[extra]=cut(source,mask_polygon(size,[(x*size[0],y*size[1]) for x,y in EXTRAS[name]]))
  if name in EXTRAS and c['tier']=='light':
   pivots={'arnoob':(.51,.30),'sinjoob':(.45,.70),'qunfood':(.51,.285),'qatqoota':(.31,.80),'ghazlana':(.16,.51),'dubb':(.39,.19),'tawoos':(.53,.53),'qarqoor':(.70,.62),'duck':(.20,.64)}
   at=pivots.get(name,(.19,.61));meta['extra_anchor']=[round(at[0]*size[0]),round(at[1]*size[1])];meta['extra_mask']=[[round(x*size[0]),round(y*size[1])] for x,y in EXTRAS[name]]
  for p in c['parts']:
   assert p['name'] in parts,(name,p['name']);parts[p['name']].save(ROOT/p['path']);p['status']='done'
  if c['tier']=='full':
   assembled=Image.new('RGBA',size)
   for part in meta['draw_order']:assembled.alpha_composite(parts[part])
   assembled.save(folder/'neutral_assembly.png')
   # Compare protected face region after restoring exact original eye/mouth crops.
   headbox=(0,0,size[0],round(size[1]*(.31 if name=='grandpa' else .39)))
   visible=[]
   for background in ['white','black']:
    before=Image.new('RGBA',size,background);before.alpha_composite(source)
    after=Image.new('RGBA',size,background);after.alpha_composite(assembled)
    diff=ImageChops.difference(after.crop(headbox).convert('RGB'),before.crop(headbox).convert('RGB'))
    visible.append(max(channel.getextrema()[1] for channel in diff.split()))
   meta['neutral_face_max_difference']=max(visible);assert max(visible)<=4,(name,visible)
  (folder/'layout.json').write_text(json.dumps(meta,indent=2)+'\n')
  rows=(len(parts)+3)//4;sheet=Image.new('RGB',(1200,360+rows*280),'#fff4de');draw=ImageDraw.Draw(sheet);draw.text((15,10),name+' — source cutouts / overlays',font=font,fill='black');thumb=source.copy();thumb.thumbnail((300,310));sheet.paste(thumb,(10,40),thumb);draw.text((330,60),f'{c["tier"].upper()} / original canvas {size}',font=font,fill='black')
  for i,(label,im) in enumerate(parts.items()):
   x=i%4*300;y=360+i//4*280;draw.text((x+8,y+5),label,font=font,fill='black');bbox=im.getbbox()
   if bbox:
    t=im.crop(bbox);t.thumbnail((280,240));sheet.paste(t,(x+10,y+32),t)
  sheet.save(ROOT/c['review'])
  print('[PARTS]',name,len(parts))
 MAN.write_text(json.dumps(data,indent=2)+'\n')
 q=ROOT/'content/art_queue.md';text=q.read_text();statuses={f"fable_{c['name']}_{p['name']}":p['status'] for c in data for p in c['parts']};lines=text.splitlines()
 for i,l in enumerate(lines):
  if not l.startswith('| fable_'):continue
  cells=[x.strip() for x in l.strip('|').split('|')]
  if cells[0] in statuses:cells[-1]=statuses[cells[0]];lines[i]='| '+' | '.join(cells)+' |'
 q.write_text('\n'.join(lines)+'\n')
if __name__=='__main__':main()
