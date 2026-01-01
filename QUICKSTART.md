# Tournament Director - Quick Reference

## File Structure
```
2stagestatsprogram/
├── index.html          → Landing Page/Dashboard
├── stage1.html         → Round Robin Entry
├── stage2.html         → Knockout Bracket
├── merger.html         → Stats Merger (Stage 3)
└── README.md           → Full Documentation
```

## Workflow Overview

### 1️⃣ STAGE 1: Round Robin
- **File**: stage1.html
- **Input**: 10 players (5 per group)
- **Process**: Score 20 matches (10 per group)
- **Output**: RR_Data.json
- **Navigation**: Auto-returns to dashboard after download

### 2️⃣ STAGE 2: Knockout
- **File**: stage2.html
- **Input**: Upload RR_Data.json
- **Process**: Auto-seeded bracket (QF → SF → Final)
- **Output**: KO_Data.json
- **Navigation**: Auto-returns to dashboard after download

### 3️⃣ STAGE 3: Merger
- **File**: merger.html
- **Input**: Upload RR_Data.json + KO_Data.json
- **Process**: Merges data + calculates Total Event 3DA
- **Output**: Event_Final_Stats.json
- **Navigation**: Auto-returns to dashboard after download

## Key Formula: Total Event 3DA

```
For each player:
  Total Event 3DA = (Sum of ALL match 3DAs) ÷ (Total matches played)
```

**NOT** an average of averages. It's the average of **every individual match 3DA**.

## Data Flow

```
Stage 1 Players → RR Matches → RR_Data.json
                                    ↓
                            Stage 2 Upload
                                    ↓
                            KO Bracket → KO_Data.json
                                    ↓
                            Stage 3 Upload Both
                                    ↓
                    Calculate Event 3DA → Event_Final_Stats.json
```

## File Outputs

| Stage | Filename | Contents |
|-------|----------|----------|
| 1 | RR_Data.json | Metadata, Standings, 20 RR matches |
| 2 | KO_Data.json | Metadata, QF/SF/Final, Champion |
| 3 | Event_Final_Stats.json | Combined data + player_event_stats |

## Critical Fields in Final Output

```json
{
  "player_event_stats": {
    "Smith, John": {
      "total_matches": 12,           // RR + KO matches
      "final_event_3da": 80.25       // Average of ALL 12 match 3DAs
    }
  }
}
```

## Navigation

All pages have "← Back to Dashboard" button in top-left corner.

All export operations automatically return you to the dashboard after 1.5 seconds.

## Start Here

**Double-click `index.html`** to open the Tournament Director Dashboard.

---
*Offline Event Management System • No server required*
