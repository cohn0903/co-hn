# Home Assistant Family Dashboard

A comprehensive Home Assistant dashboard featuring time display, calendar, weather forecasts, Houston Rockets game tracking, and a school departure countdown timer.

## Features

- **Current Time & Date Display** - Large, easy-to-read clock with date
- **5-Day Calendar View** - Shows upcoming events from multiple calendars
- **Today's Weather** - Current conditions at a glance
- **Hourly Weather Forecast** - Detailed hourly predictions
- **Weekly Weather Forecast** - 7-day forecast overview
- **Houston Rockets Tracker** - Next game info and live scores
- **School Departure Countdown** - Countdown to 7:15 AM with alerts

## Prerequisites

### Required Integrations

1. **Weather Integration** - Any weather integration that creates a `weather.home` entity
   - [Met.no](https://www.home-assistant.io/integrations/met/)
   - [OpenWeatherMap](https://www.home-assistant.io/integrations/openweathermap/)
   - [AccuWeather](https://www.home-assistant.io/integrations/accuweather/)

2. **Calendar Integration** - For the 5-day calendar view
   - [Google Calendar](https://www.home-assistant.io/integrations/google/)
   - [CalDAV](https://www.home-assistant.io/integrations/caldav/)
   - [Local Calendar](https://www.home-assistant.io/integrations/local_calendar/)

### Required HACS Custom Cards

Install these via [HACS](https://hacs.xyz/):

1. **[Atomic Calendar Revive](https://github.com/totaldebug/atomic-calendar-revive)** - 5-day calendar display
2. **[Weather Chart Card](https://github.com/Yevgenium/weather-chart-card)** - Hourly weather visualization
3. **[TeamTracker Card](https://github.com/vasqued2/ha-teamtracker)** - Sports team tracking
4. **[Timer Bar Card](https://github.com/rianadon/timer-bar-card)** - Visual countdown timer
5. **[card-mod](https://github.com/thomasloven/lovelace-card-mod)** - Card styling
6. **[Flex Table Card](https://github.com/custom-cards/flex-table-card)** - Schedule table display
7. **[Digital Clock](https://github.com/wassy92x/lovelace-digital-clock)** - Digital time display

### Optional: TeamTracker Integration

For live Rockets game tracking, install the [TeamTracker Integration](https://github.com/vasqued2/ha-teamtracker) via HACS and configure it for the Houston Rockets.

## Installation

### Step 1: Install HACS Custom Cards

1. Open HACS in Home Assistant
2. Go to "Frontend" section
3. Click "+ Explore & Download Repositories"
4. Search for and install each card listed above
5. Restart Home Assistant

### Step 2: Add Sensors

Add the contents of `sensors.yaml` to your `configuration.yaml`:

```yaml
# Option 1: Include as a separate file
template: !include sensors.yaml

# Option 2: Copy contents directly into configuration.yaml
```

### Step 3: Add Automations

Add the contents of `automations.yaml` to your automations:

```yaml
# Option 1: Include in configuration.yaml
automation: !include automations.yaml

# Option 2: Use the Automations UI to create them manually
```

### Step 4: Configure the Dashboard

1. Go to Settings > Dashboards
2. Click "+ Add Dashboard"
3. Name it "Family Dashboard"
4. Click on the new dashboard
5. Click the three dots menu > "Edit Dashboard"
6. Click three dots again > "Raw configuration editor"
7. Paste the contents of `dashboard.yaml`
8. Save and exit

### Step 5: Configure TeamTracker (for Rockets)

1. Go to HACS > Integrations
2. Search for "TeamTracker"
3. Install and restart Home Assistant
4. Go to Settings > Devices & Services > Add Integration
5. Search for "TeamTracker"
6. Configure:
   - League: NBA
   - Team: Houston Rockets
   - Name: Houston Rockets

## Customization

### Change School Departure Time

Edit the `sensors.yaml` file and change these values:

```yaml
{% set target_hour = 7 %}    # Change to your hour (24-hour format)
{% set target_minute = 15 %} # Change to your minute
```

Also update the automation trigger times in `automations.yaml`.

### Change Weather Entity

If your weather entity is not `weather.home`, replace all instances with your entity ID:

```yaml
entity: weather.your_weather_entity
```

### Customize Calendar Entities

Edit the calendar entities in `dashboard.yaml`:

```yaml
entities:
  - entity: calendar.your_calendar
    color: "#4285F4"
```

### Change Sports Team

To track a different team:

1. Reconfigure TeamTracker for your preferred team
2. Update the sensor names in `sensors.yaml` and `dashboard.yaml`
3. Update the ESPN API URL for your team's schedule:
   - NBA Team IDs: Find at [ESPN NBA Teams](https://www.espn.com/nba/teams)
   - NFL/MLB/NHL: Similar API structure with different sport paths

## File Structure

```
├── dashboard.yaml      # Main Lovelace dashboard configuration
├── sensors.yaml        # Template sensors for countdown and sports
├── automations.yaml    # Alert automations for school and games
└── README.md          # This file
```

## Troubleshooting

### Cards not appearing

1. Ensure all HACS cards are installed
2. Clear browser cache
3. Restart Home Assistant

### Weather not showing

1. Verify you have a weather integration configured
2. Check that `weather.home` exists (or update entity ID)
3. Ensure weather integration is providing forecast data

### Rockets data not updating

1. Check that the REST sensors are working in Developer Tools > States
2. The ESPN API might have rate limits - sensor updates every hour
3. Consider using TeamTracker integration for more reliable updates

### Countdown timer not updating

Template sensors update every minute by default. For more frequent updates:

```yaml
homeassistant:
  customize:
    sensor.school_departure_countdown:
      scan_interval: 1
```

## Screenshots

The dashboard includes:
- Dark themed cards with gradient backgrounds
- Rockets-themed red/black color scheme for sports cards
- Warning-colored countdown timer (orange/red)
- Clean weather visualization

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT License - Feel free to use and modify as needed.
