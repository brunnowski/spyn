# SPYN 📍

**SPYN Your Journey** - Transform your photo memories into interactive route maps

[![GitHub Pages](https://img.shields.io/badge/demo-live-brightgreen)](https://brunnowski.github.io/hyfa/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🌟 About

SPYN is a web application that automatically creates beautiful, interactive route maps from your photos' GPS data. Upload your journey photos, and watch as SPYN traces your path on a map, preserving every moment of your adventure.

Perfect for travelers, hikers, road trippers, and anyone who wants to visualize their journeys.

## ✨ Features

- 📸 **Smart Photo Processing** - Automatic GPS extraction from EXIF data
- 🗺️ **Interactive Maps** - Powered by Maplibre GL with OpenStreetMap tiles
- 🛣️ **Route Generation** - Intelligent routing using OSRM API
- 📱 **Responsive Design** - Beautiful brutalist UI that works on all devices
- 🔐 **User Authentication** - Secure login/signup with Supabase
- 💾 **Cloud Storage** - Routes saved to Supabase database
- 🎨 **Photo Carousel** - Swipeable photo viewer with touch support
- 🔗 **Route Sharing** - Share your journeys with a simple link
- ✏️ **Route Management** - Edit, update, or delete your routes
- 👤 **User Profiles** - Personal dashboard with statistics and all your routes
- 📊 **Public Feed** - Discover and explore routes from other travelers
- ❤️ **Social Interactions** - Like and comment on routes
- 💬 **Comments System** - Engage with other travelers

## 🚀 Quick Start

### Live Demo

Visit the live application: **[https://brunnowski.github.io/hyfa/](https://brunnowski.github.io/hyfa/)**

📱 **Access from any device** - smartphone, tablet, or desktop!

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/brunnowski/hyfa.git
   cd hyfa
   ```

2. **Start a local server**
   ```bash
   python3 -m http.server 3000
   ```

3. **Open in browser**
   ```
   http://localhost:3000
   ```

## 🔧 Setup & Configuration

### Supabase Setup (Optional but Recommended)

SPYN works with localStorage by default, but for a better experience with user authentication and cloud storage, set up Supabase:

1. **Create a Supabase account** at [supabase.com](https://supabase.com)

2. **Create a new project**

3. **Get your credentials** from Settings → API:
   - Project URL
   - Anon public key

4. **Update `index.html`** with your credentials:
   ```javascript
   const SUPABASE_URL = 'your-project-url';
   const SUPABASE_ANON_KEY = 'your-anon-key';
   ```

5. **Run the database setup** - Execute `database_setup.sql` in your Supabase SQL Editor

6. **Configure Redirect URLs** in Supabase Dashboard → Authentication → URL Configuration:
   - Add your development URLs (e.g., `http://localhost:3000`)
   - Add your production URL (`https://brunnowski.github.io/hyfa/`)

## 📖 How to Use

1. **Upload Photos**
   - Click "Upload Photos" on the landing page
   - Select multiple photos with GPS data (EXIF location info)
   - Photos are automatically sorted by timestamp

2. **Generate Route**
   - Add a route name and description
   - Click "Generate Route"
   - Watch as your journey comes to life on the map!

3. **View & Explore**
   - Click photo markers to view full-size images
   - Swipe through photos in the carousel
   - Share your route with friends

4. **Save & Manage**
   - Create an account to save routes to the cloud
   - View all your routes in your profile
   - Edit route details anytime

## 🎨 Design

SPYN features a bold **brutalist design** aesthetic:
- High contrast black, white, yellow, red, and blue color scheme
- Thick borders and prominent shadows
- Uppercase typography
- Mobile-first responsive layout

## 🛠️ Technologies

- **Frontend**: Vanilla JavaScript, HTML5, CSS3
- **Maps**: [Maplibre GL JS](https://maplibre.org/) v4.0.0
- **Routing**: [OSRM](https://project-osrm.org/) API
- **Authentication**: [Supabase](https://supabase.com/) Auth
- **Database**: Supabase PostgreSQL
- **EXIF Parsing**: [exif-js](https://github.com/exif-js/exif-js)

## 📁 Project Structure

```
hyfa/
├── index.html              # Main application file (SPA)
├── README.md               # Project documentation
├── database_setup.sql      # Complete database schema and policies
├── TERMS_OF_SERVICE.md     # Terms of service and legal information
└── .github/                # GitHub Actions workflows
```

## 🌐 Browser Compatibility

- ✅ Chrome/Edge (90+)
- ✅ Firefox (88+)
- ✅ Safari (14+)
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## 📝 Requirements

Photos must contain:
- **GPS EXIF data** (latitude and longitude)
- **DateTime EXIF data** (for proper ordering)

Most modern smartphones automatically add this data to photos when location services are enabled.

## 🔒 Privacy & Security

- Photos are compressed client-side before storage
- Row-Level Security (RLS) policies protect user data
- User routes are public by default (visible in feed)
- Share links provide easy route sharing
- By creating an account, you agree to our [Terms of Service](TERMS_OF_SERVICE.md)

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## 📄 License

This project is licensed under the MIT License.

## 📜 Terms of Service

By creating an account on SPYN, you agree to our [Terms of Service](TERMS_OF_SERVICE.md).

**Key points:**
- You retain all rights to your photos and routes
- Routes are public by default and visible in the feed
- You must be at least 13 years old to use the service
- Content must comply with our community guidelines
- We use Supabase for data storage and authentication

Read the full [Terms of Service](TERMS_OF_SERVICE.md) for complete details.

## 🙏 Acknowledgments

- OpenStreetMap contributors
- Maplibre GL team
- OSRM project
- Supabase team

## 📧 Contact

Created by [@brunnowski](https://github.com/brunnowski)

---

**SPYN** - Every journey tells a story 🗺️✨

