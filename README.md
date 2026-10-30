# Starrock Trading Journal — Cloud Edition

A monochrome, Apple-inspired interface with Supabase email/password authentication and per-user cloud journal storage.

## What changed
- Black, white and grey visual system with an Apple-style system font stack.
- Email + password sign-in and account creation.
- Journal data syncs to Supabase so the same account can access it across devices.
- Row Level Security (RLS) restricts each account to its own journal row.
- Existing dashboard, trade log, screenshots, calendar, analytics, review, risk calculator, prop tracker, CSV import/export and JSON backup remain available.

## Setup before hosting

### 1. Create a Supabase project
1. Create a project at https://supabase.com.
2. Open **SQL Editor** in the Supabase dashboard.
3. Paste and run the contents of `supabase-setup.sql`.
4. Open **Project Settings → API** (or **Data API**) and copy the Project URL and the `anon` / publishable public key.

### 2. Add your public project settings
Open `index.html` and find:

```js
const SUPABASE_URL='YOUR_SUPABASE_PROJECT_URL';
const SUPABASE_ANON_KEY='YOUR_SUPABASE_ANON_KEY';
```

Replace those two placeholders with your Supabase Project URL and anon/publishable key. These are designed to be public in a browser app. **Never put a Supabase `service_role` key or database password in this file.** The database is protected by the included RLS policies.

### 3. Configure authentication
In Supabase **Authentication → URL Configuration**, add your deployed website URL to the Site URL and Redirect URLs. For a personal private journal, turn off public sign-ups after you have created your account, if you do not want anyone else creating an account. Create your own account first. You can also require email confirmation in Supabase Auth settings.

### 4. Host it
Upload `index.html` to a static host such as Netlify, Vercel, or Cloudflare Pages. No build step is required. Keep `supabase-setup.sql` private or alongside your project documentation; it is not needed by the browser at runtime.

## Moving existing data
If you have trade data in the old local-only version, open that old version on the computer/browser where the data lives, export a JSON backup, then sign in to this cloud version on the same browser. The first cloud login imports the old local browser data automatically if your cloud journal is empty. If you need to migrate from a different browser/device, restore your JSON backup using the Data & Settings restore control after signing in.

## Important notes
- The login is real Supabase authentication; it is not a client-side password overlay.
- Cloud rows are isolated by Supabase Row Level Security. Use only the anon/publishable key in the page; never expose a service-role key.
- Screenshots are currently stored inside the journal JSON payload as base64 data. Keep screenshots reasonably compressed; for a large screenshot archive, a dedicated private Supabase Storage bucket is a better next upgrade.
- The app keeps a local browser cache as well as cloud storage. Cloud is loaded when signing in; changes are uploaded to the authenticated user's row.
- A static frontend hosted on a public URL is not itself private. Supabase protects the journal data and login; the app shell may still be downloaded by visitors.
- Export JSON backups regularly. This is a personal trading journal, not a broker-connected execution system.
