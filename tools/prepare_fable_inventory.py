"""Read-only summary of the reduced Fable manifest. Never revive cancelled rows."""
import json
from pathlib import Path
from collections import Counter
root=Path(__file__).resolve().parents[1]
data=json.loads((root/'docs/rigs/character_manifest.json').read_text())
print(dict(Counter(c['tier'] for c in data)))
print('Active image deliverables:',sum(len(c['parts']) for c in data))
