# Results Folder

Place your Final_SeriesX_EventY.json files here after merging each event.

## File Naming Convention

Your files will be automatically named in this format:
- Series 1, Event 1 → `Final_Series1_Event1.json`
- Series 1, Event 2 → `Final_Series1_Event2.json`
- Series 2, Event 1 → `Final_Series2_Event1.json`

## Example Structure

```
results/
├── Final_Series1_Event1.json
├── Final_Series1_Event2.json
├── Final_Series1_Event3.json
├── Final_Series2_Event1.json
└── Final_Series2_Event2.json
```

## Important Notes

1. Keep the naming consistent: `Final_Series[X]_Event[Y].json`
2. This ensures no accidental overwrites when running multiple events
3. The career.html page will auto-scan all files in this folder
4. Don't put player_profiles.json here (it goes in the main folder)

## After Adding a New Event File

1. Save your merged event file here
2. Refresh career.html
3. Career stats automatically update!

No manual updates needed! 🎉
