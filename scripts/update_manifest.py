import json
import re
from pathlib import Path
from datetime import date

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / 'results'
MANIFEST = RESULTS / 'manifest.json'

LEGACY_RE = re.compile(r'Final_Series(\d+)_Event(\d+)\.json', re.IGNORECASE)
NEW_RE = re.compile(r'final_([a-z0-9]+)_series(\d+)_event(\d+)\.json', re.IGNORECASE)


def load_manifest():
    if MANIFEST.exists():
        return json.loads(MANIFEST.read_text())
    return {"available_events": [], "series_name": "", "series_id": 1, "current_event": 1, "last_updated": str(date.today())}


def scan_results(manifest):
    available = set()
    files = sorted([p.name for p in RESULTS.iterdir() if p.is_file() and p.suffix.lower() == '.json'])
    for fname in files:
        m = LEGACY_RE.match(fname)
        if m:
            series_num = int(m.group(1))
            event_id = int(m.group(2))
            # Keep numeric entries only for the manifest's primary series
            if series_num == int(manifest.get('series_id', 1)):
                available.add(event_id)
            continue

        n = NEW_RE.match(fname)
        if n:
            # for non-legacy series, include the filename so display can detect string series
            available.add(fname)
            continue

        # Keep existing manifest file entries if they are strings and exist on disk
        # (handled later)

    # Preserve any other string entries from existing manifest if they still exist
    for entry in manifest.get('available_events', []):
        if isinstance(entry, str):
            p = RESULTS / entry
            if p.exists():
                available.add(entry)

    # Sort numeric then strings
    nums = sorted([e for e in available if isinstance(e, int)])
    strs = sorted([e for e in available if isinstance(e, str)])
    return nums + strs


def write_manifest(manifest, available):
    # Keep other manifest fields, but update available_events, current_event (max numeric), last_updated
    manifest['available_events'] = available
    numeric = [e for e in available if isinstance(e, int)]
    if numeric:
        manifest['current_event'] = max(manifest.get('current_event', 0), max(numeric))
    manifest['last_updated'] = str(date.today())
    MANIFEST.write_text(json.dumps(manifest, indent=2))
    print(f"Wrote manifest with {len(available)} entries to {MANIFEST}")


def main():
    manifest = load_manifest()
    available = scan_results(manifest)
    write_manifest(manifest, available)


if __name__ == '__main__':
    main()
