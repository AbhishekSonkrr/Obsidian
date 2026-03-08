---
date: <% tp.file.title %>T<% tp.date.now("HH:mm") %>
tags: Daily
cssclasses:
  - daily
  - <% tp.date.now("dddd", 0, tp.file.title, "YYYY-MM-DD").toLowerCase() %>
---

# <% tp.date.now("YYYY-MM-DD", 0, tp.file.title, "YYYY-MM-DD") %>
## <% tp.date.now("dddd, MMMM Do", 0, tp.file.title, "YYYY-MM-DD") %>

---

```dataviewjs
// 1. Progress Bar Logic
try {
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 9, 0, 0); 
    const end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 18, 0, 0);  

    let percent = 0;
    if (now > end) percent = 100;
    else if (now > start) {
        percent = Math.round(((now - start) / (end - start)) * 100);
    }

    const barFull = 20; 
    const progress = Math.round((percent / 100) * barFull);
    const bar = "█".repeat(progress) + "░".repeat(barFull - progress);

    dv.paragraph(`### Day Progress: ${percent}%`);
    dv.paragraph(`\`${bar}\``);
} catch (e) {
    dv.paragraph("> [!error] Progress bar failed.");
}
```

---

<%* // 2. MNNIT MCA Schedule Logic
try { 
    const day = tp.date.now("dddd", 0, tp.file.title, "YYYY-MM-DD"); 
    const timetable = { 
        "Monday": "- [ ] `10:00–11:00` A T (104)\n- [ ] `11:00–01:00` OOP (102)\n- [ ] `02:00–05:00` D S LAB (201)", 
        "Tuesday": "- [ ] `09:00–11:00` D S (101)\n- [ ] `02:00–05:00` OOP Lab (203)", 
        "Wednesday": "- [ ] `10:00–12:00` A T (104)\n- [ ] `12:00–01:00` OOP (102)\n- [ ] `03:00–05:00` XML (103)", 
        "Thursday": "- [ ] `11:00–01:00` D S (101)\n- [ ] `02:00–05:00` XML LAB (202)\n- [ ] `05:00–06:00` XML (103)", 
        "Friday": "- [ ] `03:00–05:00` T W (105)" 
    };

    const schedule = timetable[day] || "### Weekend\n- [ ] Self-study & Revision";
    tR += (timetable[day] ? "### Today's Classes\n" : "") + schedule;
} catch (e) { 
    tR += "> [!error] Schedule failed."; 
} 
%>

---

## Attendance Tracker
```dataviewjs
// 3. Robust Attendance Tracker
try {
    const pages = dv.pages('"Daily"').filter(p => {
        const fileDate = moment(p.file.name, "YYYY-MM-DD");
        return fileDate.isValid() && !fileDate.isAfter(moment(), 'day');
    });

    const stats = {};
    const tasks = pages.file.tasks.filter(t => t.text && /\d{2}:\d{2}/.test(t.text));

    tasks.forEach(t => {
        const match = t.text.match(/`\d{2}:\d{2}.*?` (.*)/);
        if (match && match[1] && match[1].trim().length > 0) {
            const sub = match[1].trim();
            if (!stats[sub]) stats[sub] = { a: 0, t: 0 };
            stats[sub].t++;
            if (t.completed) stats[sub].a++;
        }
    });

    const rows = Object.entries(stats).map(([name, data]) => {
        const pct = data.t ? (data.a / data.t) * 100 : 0;
        const color = pct < 75 ? "#ff5c8d" : (pct < 85 ? "#ffd600" : "#26e6b4");
        
        let req = 0;
        let tempA = data.a;
        let tempT = data.t;
        while ((tempA / tempT) < 0.75 && req < 50) {
            req++; tempA++; tempT++;
        }

        return [
            `**${name}**`,
            `${data.a}/${data.t}`,
            `<span style="color:${color}; font-weight:bold;">${pct.toFixed(0)}%</span>`,
            pct < 75 ? `+${req}` : "✓"
        ];
    });

    if (rows.length > 0) {
        dv.table(["Subj", "Att/Tot", "%", "Goal"], rows);
    } else {
        dv.paragraph("*No past attendance records found.*");
    }
} catch (err) {
    dv.paragraph("> [!error] Attendance logic error.");
}
```

### Note
- [ ]