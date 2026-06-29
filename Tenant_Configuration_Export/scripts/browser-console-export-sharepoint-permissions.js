// Read-only SharePoint permissions export.
// Run from a browser session already signed in to https://samstack.sharepoint.com.
// Uses GET requests only and does not change any site.

async function exportSmlcSharePointPermissions() {
    const domain = "samstack.onmicrosoft.com";
    // This list matches output/SharePoint/01_SiteList.csv. System sites
    // and private channel sub-sites are excluded because they do not expose
    // Owners, Members, and Visitors groups in the same way as standard sites.
    const sites = {
        "All-Company": "https://samstack.sharepoint.com/sites/allcompany",
        "SMLC-Knowledge-Base": "https://samstack.sharepoint.com/sites/msteams_aabb57",
        "Nackademin": "https://samstack.sharepoint.com/sites/Nackademin",
        "SMLC-Admins": "https://samstack.sharepoint.com/sites/SMLC-Admins",
        "SMLC-All-Staff": "https://samstack.sharepoint.com/sites/SMLC-All-Staff",
        "SMLC-BizOps": "https://samstack.sharepoint.com/sites/SMLC-BizOps",
        "SMLC-BR-Staff": "https://samstack.sharepoint.com/sites/SMLC-BR-Staff",
        "SMLC-FieldOps": "https://samstack.sharepoint.com/sites/SMLC-FieldOps",
        "SMLC-Finance": "https://samstack.sharepoint.com/sites/SMLC-Finance",
        "SMLC-HelpDesk": "https://samstack.sharepoint.com/sites/SMLC-HelpDesk",
        "SMLC-HQ-Staff": "https://samstack.sharepoint.com/sites/SMLC-HQ-Staff",
        "SMLC-ITInfra": "https://samstack.sharepoint.com/sites/SMLC-ITInfra",
        "SMLC-MgmtAdmin": "https://samstack.sharepoint.com/sites/SMLC-MgmtAdmin",
        "SMLC-Policies": "https://samstack.sharepoint.com/sites/SMLC-Policies",
        "SMLC-Support": "https://samstack.sharepoint.com/sites/SMLC-Support",
        "SMLC-TechOps": "https://samstack.sharepoint.com/sites/SMLC-TechOps",
        "SMLC-Templates": "https://samstack.sharepoint.com/sites/SMLC-Templates"
    };

    async function readGroup(siteUrl, roleEndpoint) {
        const res = await fetch(`${siteUrl}/_api/web/${roleEndpoint}/users`, {
            headers: { "Accept": "application/json;odata=verbose" }
        });
        if (!res.ok) return [];
        const data = await res.json();
        return data.d.results.map(u => u.LoginName || u.Title);
    }

    const results = [];
    for (const [name, siteUrl] of Object.entries(sites)) {
        try {
            const owners = await readGroup(siteUrl, "associatedownergroup");
            const members = await readGroup(siteUrl, "associatedmembergroup");
            const visitors = await readGroup(siteUrl, "associatedvisitorgroup");
            results.push({ Site: name, Owners: owners.join(";"), Members: members.join(";"), Visitors: visitors.join(";") });
            console.log(`[OK] ${name}`);
        } catch (e) {
            results.push({ Site: name, Owners: "", Members: "", Visitors: "", Error: e.message });
            console.log(`[FAILED] ${name}: ${e.message}`);
        }
    }

    console.table(results);
    console.log("CSV export:");
    const csv = "Site,Owners,Members,Visitors\n" + results.map(r => `"${r.Site}","${r.Owners}","${r.Members}","${r.Visitors}"`).join("\n");
    console.log(csv);
    return results;
}

exportSmlcSharePointPermissions();
