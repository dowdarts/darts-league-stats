# Darts Tournament Admin System - User Guide

## Overview
This is a 3-stage offline Darts Admin system with a central landing page (Tournament Director Dashboard).

**Files:**
- **index.html** - Landing Page with 3 stage buttons
- **stage1.html** - Round Robin Entry
- **stage2.html** - Knockout Bracket
- **merger.html** - Stats Merger (Stage 3)

## Quick Start Workflow

### Dashboard → Stage 1 → Stage 2 → Stage 3

1. Open **index.html** in your browser (the Tournament Director Dashboard)
2. Click **Stage 1: Round Robin** button
3. Complete Round Robin, download `RR_Data.json`, auto-returns to dashboard
4. Click **Stage 2: Knockout** button
5. Upload `RR_Data.json`, complete bracket, download `KO_Data.json`, auto-returns to dashboard
6. Click **Stage 3: Stats Merger** button
7. Upload both files, download `Event_Final_Stats.json`, auto-returns to dashboard

## Detailed Instructions

### Stage 1: Round Robin Entry (stage1.html)

**Purpose**: Manage group stage matches and generate seeding data

**Steps**:
1. Enter series number (1-10) and event number (1-7, where 7 = Tournament of Champions)
2. Enter 5 players per group (Group A and Group B) in "Last, First" format
   - Example: `Smith, John`
3. Click "Generate Round Robin" to create 10 matches per group
4. Score matches using the leg inputs (0-3 legs per match, first to 3 wins)
5. Click "Details" button on any match to enter detailed stats:
   - 3 Dart Average (3DA)
   - 180s count
   - 100+ and 140+ score counts
   - Checkout opportunities, completions, and percentage
   - High finish
6. Live standings update automatically with tie-breaker logic
7. Click "Download RR_Data.json & Return to Dashboard"
   - File downloads automatically
   - Page redirects to dashboard after 1.5 seconds

**Key Features**:
- Auto-save to localStorage (data persists on refresh)
- Name formatting: accepts "Last, First" but displays "First Last"
- Top 4 from each group highlighted in green (these qualify for knockout)
- Tie-breaker: Primary by total legs won, secondary by head-to-head result

### Stage 2: Knockout Bracket (stage2.html)

**Purpose**: Manage knockout stage with auto-seeding from Round Robin

**Steps**:
1. Click "Choose File" and select the `RR_Data.json` file from Stage 1
2. Click "Load RR Data & Generate Bracket" button
3. System auto-seeds Quarter Finals:
   - QF1: Group A 1st vs Group B 4th
   - QF2: Group A 2nd vs Group B 3rd
   - QF3: Group B 1st vs Group A 4th
   - QF4: Group B 2nd vs Group A 3rd
4. Enter sets and legs for each match
   - Best of 5 sets (first to 3 wins)
   - System auto-progresses winners to Semi Finals and Final
5. Click "Detailed Stats" on any match to enter full statistics
6. Champion automatically displays when Final winner is determined
7. Click "Download KO_Data.json & Return to Dashboard"
   - File downloads automatically
   - Page redirects to dashboard after 1.5 seconds

**Key Features**:
- No manual seeding - automatic from RR standings
- Auto-progression: QF winners → SF, SF winners → Final
- TBD placeholders until previous round completes
- Same detailed stats modal as Round Robin

### Stage 3: Stats Merger (merger.html)

**Purpose**: Combine Round Robin and Knockout data + Calculate Total Event 3DA

**Steps**:
1. Upload Round Robin JSON (RR_Data.json)
2. Upload Knockout JSON (KO_Data.json)
3. System validates both files are from same event
4. Preview shows match counts and champion
5. Click "Merge & Download Final JSON" button
6. Downloads as `Event_Final_Stats.json`
7. Auto-returns to dashboard after 1.5 seconds

**Key Features**:
- Event ID validation (prevents merging wrong events)
- Live preview of both datasets
- **Smart 3DA Calculation**: For each player, the system:
  - Collects ALL 3DA values from every match in both RR and KO stages
  - Calculates the average: (Sum of all 3DAs) ÷ (Total matches played)
  - Stores as `final_event_3da` in the output
- Output includes `player_event_stats` section with:
  - `total_matches`: Number of matches played across entire event
  - `final_event_3da`: Average of all match 3DAs

## File Naming Convention

- Round Robin: `RR_Data.json`
- Knockout: `KO_Data.json`
- Final Merged: `Event_Final_Stats.json`

## Data Structure

### Round Robin JSON (RR_Data.json)
```json
{
  "metadata": {
    "series_id": 1,
    "event_id": 1,
    "event_name": "Series 1 - Event 1",
    "date": "2024-01-15"
  },
  "standings": {
    "groupA": [/* sorted array of player standings */],
    "groupB": [/* sorted array of player standings */]
  },
  "matches": {
    "groupA": [/* 10 matches with detailed stats */],
    "groupB": [/* 10 matches with detailed stats */]
  }
}
```

### Knockout JSON (KO_Data.json)
```json
{
  "metadata": { /* same as RR */ },
  "knockout": {
    "quarterFinals": [/* 4 matches */],
    "semiFinals": [/* 2 matches */],
    "final": { /* 1 match */ },
    "champion": "Smith, John"
  }
}
```

### Final Merged JSON (Event_Final_Stats.json)
```json
{
  "metadata": { /* event metadata */ },
  "round_robin": {
    "standings": { /* groupA and groupB */ },
    "matches": { /* groupA and groupB */ }
  },
  "knockout": { /* full knockout bracket */ },
  "player_event_stats": {
    "Smith, John": {
      "total_matches": 12,
      "final_event_3da": 78.45
    }
  }
}
```

## Total Event 3DA Calculation

The merger performs "Average of Averages" calculation:

**Example**: Player "Smith, John" plays:
- 10 RR matches with 3DAs: 75, 80, 82, 78, 81, 79, 77, 83, 76, 80
- 2 KO matches with 3DAs: 85, 87

**Calculation**:
- Sum ALL 3DAs: 75+80+82+78+81+79+77+83+76+80+85+87 = 963
- Total matches: 12
- Final Event 3DA = 963 ÷ 12 = **80.25**

The system **does NOT** average the RR average and KO average. It averages **every individual match 3DA** from the entire event.

## Navigation Flow

```
Dashboard (index.html)
    ↓
Stage 1 (stage1.html) → Download RR_Data.json → Auto-return to Dashboard
    ↓
Stage 2 (stage2.html) → Upload RR_Data.json → Download KO_Data.json → Auto-return to Dashboard
    ↓
Stage 3 (merger.html) → Upload both → Download Event_Final_Stats.json → Auto-return to Dashboard
```

## Tips & Best Practices

1. **Always start from the Dashboard** - It provides clear workflow guidance
2. **Name Entry**: Always use "Last, First" format for consistency with DartConnect
3. **Save RR Data before leaving Stage 1** - Required for Stage 2
4. **Save KO Data before leaving Stage 2** - Required for Stage 3
5. **Event 7**: Automatically labeled "Tournament of Champions" in dropdown
6. **File Management**: Keep downloaded files organized for easy access
7. **3DA Entry**: Enter accurate 3DA values - the merger uses these for final calculations

## Troubleshooting

**Problem**: Can't proceed to Stage 2
**Solution**: Make sure you downloaded RR_Data.json from Stage 1 first

**Problem**: Bracket shows "TBD"
**Solution**: Complete and enter winners for previous round matches

**Problem**: Can't merge files
**Solution**: Ensure both files have matching series_id and event_id

**Problem**: Player 3DA seems wrong in final stats
**Solution**: Check that 3DA was entered for ALL matches in both RR and KO stages

**Problem**: Auto-redirect isn't working
**Solution**: Make sure JavaScript is enabled in your browser

## Browser Compatibility

All files work in modern browsers:
- Chrome/Edge (recommended)
- Firefox
- Safari

**No server required** - all files run locally in the browser.
