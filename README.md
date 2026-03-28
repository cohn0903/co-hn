# Cohn Family Dashboard

A Home Assistant Lovelace dashboard for displaying family information including weather, calendar events, Houston Rockets game tracking, and school departure countdown.

## Entity Configuration

This dashboard is configured to use the following entities:

| Feature | Entity ID |
|---------|-----------|
| Weather | `weather.forecast_home` |
| Calendar | `calendar.cohn_shared_calendar` |
| Team Tracker | `sensor.team_tracker` |

## Prerequisites

### Required Integrations

1. **Weather Integration** - Any weather integration that provides `weather.forecast_home`
2. **Calendar Integration** - Google Calendar, CalDAV, or local calendar providing `calendar.cohn_shared_calendar`
3. **Team Tracker** (HACS) - For Houston Rockets game tracking

### Optional HACS Frontend Components

For the full visual experience, install these from HACS:

- [Bubble Card](https://github.com/Clooos/Bubble-Card) - Section separators
- [Mushroom Cards](https://github.com/piitaya/lovelace-mushroom) - Modern card styling
- [Atomic Calendar Revive](https://github.com/totaldebug/atomic-calendar-revive) - Enhanced calendar display
- [card-mod](https://github.com/thomasloven/lovelace-card-mod) - Custom CSS styling

## Installation

### 1. Install Team Tracker Integration

```yaml
# Install via HACS: https://github.com/vasqued2/ha-teamtracker
# Configure via UI: Settings -> Devices & Services -> Add Integration -> Team Tracker
# Select: League = NBA, Team = Houston Rockets
```

### 2. Add Template Sensors

Add the contents of `sensors.yaml` to your `configuration.yaml`:

```yaml
template: !include sensors.yaml
```

Or copy the sensor configurations directly into your existing template section.

### 3. Add the Dashboard

1. Go to Settings -> Dashboards -> Add Dashboard
2. Choose "Take control" and create a new dashboard
3. Click the three dots menu -> Edit Dashboard -> Raw Configuration Editor
4. Paste the contents of `dashboard.yaml`
5. Save

### 4. Add Automations (Optional)

Import automations from `automations.yaml` via:
- Settings -> Automations & Scenes -> Create Automation -> Edit in YAML
- Or add to your `automations.yaml` file

## Customization

### School Departure Time

Edit `sensors.yaml` to change the departure time (default 7:15 AM):

```yaml
{% set target_hour = 7 %}
{% set target_minute = 15 %}
```

### Automation Entities

Update these entities in `automations.yaml` to match your setup:

- `light.kitchen` - Light for visual alerts
- `media_player.living_room` - Speaker for TTS announcements
- `tts.google_en_com` - TTS service

## Files

| File | Description |
|------|-------------|
| `dashboard.yaml` | Main Lovelace dashboard configuration |
| `sensors.yaml` | Template sensors for countdown and time display |
| `automations.yaml` | Alert automations for school and Rockets games |

## Features

### Weather Card
- Current conditions from `weather.forecast_home`
- Temperature with color-coded icon
- Humidity, wind speed, and pressure chips
- Daily forecast display

### Calendar Card
- Events from `calendar.cohn_shared_calendar`
- Week view with upcoming events
- Event reminders via automation

### Houston Rockets Tracker
- Live game scores from `sensor.team_tracker`
- Next game information
- Pre-game, live, and final score notifications

### School Countdown
- Real-time countdown to departure
- Color-coded urgency (green -> yellow -> red)
- Weekend detection
- 15-minute and 5-minute warnings with TTS
