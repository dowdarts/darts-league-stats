# 🚀 QUICK SETUP GUIDE

## What You Now Have

✅ **Stage 1-3**: Event management (Round Robin → Knockout → Merger)  
✅ **Profile Editor**: Player bios with photo embedding  
✅ **Career Hub**: Automatic career stats across all events  

## 📁 Required Folder Structure

Create this structure in your project:

```
2stagestatsprogram/
├── index.html
├── stage1.html
├── stage2.html
├── merger.html
├── profile_editor.html
├── career.html
├── player_profiles.json        👈 Create this (download from Profile Editor)
└── results/                    👈 Create this folder
    ├── Final_Series1_Event1.json      👈 Add your event files here
    ├── Final_Series1_Event2.json
    └── Final_Series1_Event3.json
```

## ⚡ 3-Step Setup

### STEP 1: Run Your First Event

1. Open `index.html` → Click **Stage 1**
2. Select "Series 1, Event 1"
3. Enter players and score matches
5. Download `RR_Series1_Event1.json`
5. Go to **Stage 2** → Upload RR data
6. Score knockout bracket
7. Download `KO_Series1_Event1.json`
8. Go to **Stage 3** → Upload both files
9. Download `Final_Series1_Event1.json`

### STEP 2: Create Results Folder

In your project folder, create a new folder named `results`:

```
Right-click → New Folder → Name it "results"
```

Move your `Final_Series1_Event1.json` into this folder:
- The file is already correctly named!

### STEP 3: Create Player Profiles

1. Open `profile_editor.html`
2. Click **"Import Players"** and select `Final_Series1_Event1.json`
3. All players auto-appear with blank profiles
4. Click **Edit** on each player:
   - Add nickname, hometown, darts setup
   - Upload photo (auto-converts to Base64)
   - Add bio
   - Click **"Add/Update Player"**
5. Click **"Download player_profiles.json"**
6. Save it in the MAIN folder (not in results/)

## 🎯 View Career Stats

### For Local Viewing:

1. Install **Live Server** extension in VS Code
2. Right-click `career.html` → **"Open with Live Server"**
3. Career Hub opens showing all players!

### Without VS Code:

Open PowerShell in your project folder:
```powershell
python -m http.server 8000
```
Then go to: `http://localhost:8000/career.html`

## 📊 How It Works

### The Magic:

When you open `career.html`:
1. It scans `results/Event_1_Final.json`, `Event_2_Final.json`, etc.
2. Finds all players across ALL events
3. Calculates career statistics automatically
4. Pulls photos from `player_profiles.json`
5. Displays everything with charts!

### Career 3DA Calculation:

```
Event 1: John = 85.5 across 8 matches
Event 2: John = 88.2 across 6 matches
Career 3DA = (85.5×8 + 88.2×6) ÷ 14 = 86.64 ✨
```

## 🔄 Adding More Events

### For Event 2:

1. Open `stage1.html`
2. Select "Series 1, Event 2" (data starts fresh!)
3. Follow same workflow (RR → KO → Merger)
4. Save as `Final_Series1_Event2.json` in `results/` folder
5. Refresh `career.html` → **Career stats auto-update!**

### For New Players:

1. After merging new event
2. Open `profile_editor.html`
3. Import the new event file
4. Only new players get added
5. Re-download `player_profiles.json`

## 🌐 GitHub Hosting

### To Make It Public:

1. Create GitHub repository
2. Upload all files (keep folder structure!)
3. Enable GitHub Pages in Settings
4. Access at: `https://yourusername.github.io/reponame/career.html`

### Important:
- `player_profiles.json` goes in root
- Event files go in `results/` folder
- Career page needs to be opened via a server (not just file://)

## ✅ Checklist

- [ ] Ran Stage 1 → 2 → 3 for Event 1
- [ ] Created `results/` folder
- [ ] Moved `Event_Final_Stats.json` → `results/Event_1_Final.json`
- [ ] Opened `profile_editor.html` and imported event
- [ ] Added profiles (photos, bios) for all players
- [ ] Downloaded `player_profiles.json` to main folder
- [ ] Opened `career.html` with Live Server
- [ ] Saw player roster with career stats!

## 🎉 You're Done!

Now every time you run a new event:
1. Complete Stages 1-3
2. Save as `Event_X_Final.json` in `results/`
3. Career Hub updates automatically!

No need to edit profiles or manually calculate stats ever again! 🚀

---

**Questions?** Open the browser console (F12) to see any errors.
