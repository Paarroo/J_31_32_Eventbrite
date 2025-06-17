# 🎫 Eventbrite Clone - Discover Amazing Events! ✨

## 📚 Overview

Welcome to **Eventbrite Clone** - a modern event management platform built with Ruby on Rails where organizers can create events and participants can discover and join amazing experiences! Create workshops, parties, conferences, or any gathering you can imagine! 🎉

Perfect for learning Rails while building a real-world application that brings people together!

## 🎯 What Can You Do?

### 👤 **For Event Organizers**

- 📅 **Create Events**: Set up detailed events with dates, prices, and locations
- 👥 **Manage Participants**: View who's attending your events
- ✏️ **Edit & Update**: Modify event details anytime
- 📊 **Track Success**: See participation statistics
- 💌 **Email Notifications**: Automatic emails when someone joins

### 🎪 **For Event Participants**

- 🔍 **Discover Events**: Browse through exciting upcoming events
- 🎟️ **Join Events**: One-click registration with secure payment tracking
- 👤 **Profile Management**: Update your information and preferences
- 📱 **Modern Interface**: Beautiful, responsive design with Bulma CSS
- 🏠 **Personal Dashboard**: View your created events and participations

## 🚀 Quick Start

### Prerequisites

- Ruby 3.1+
- Rails 8.0+
- Basic terminal knowledge
- A love for events! 🎊

### Installation

1. **Clone the project**

   ```bash
   git clone [your-repo-url]
   cd eventbrite-clone
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Setup database**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**

   ```bash
   rails server
   ```

5. **Visit your app** Open `http://localhost:3000` in your browser and start exploring! 🚀

## 🎭 Demo Data

After running the seed, you'll have:

- **5 Demo Users** with realistic French names and emails
- **10+ Sample Events** including workshops, concerts, and meetups
- **Random Participations** to see the platform in action

Login with any user using:

- **Email**: `user1@yopmail.com` to `user5@yopmail.com`
- **Password**: `password123`

## 🏗️ How It Works

The platform connects **event organizers** with **participants** through:

```text
👤 Users ──┬─→ 📅 Events ──┬─→ 🎟️ Attendances
           │               │
           │               └─→ 💰 Pricing & Locations
           │
           └─→ 👥 Participants
```

---

**Built with 💝 as part of learning Ruby on Rails!**

🎉 _"Every great event starts with someone brave enough to organize it"_ ✨

**Ready to create your next amazing event? Let's get started!** 🚀
