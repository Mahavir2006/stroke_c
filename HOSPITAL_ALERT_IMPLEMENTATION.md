# Hospital Alert Feature Implementation

## ✅ Completed Frontend Implementation

### 1. UI Components
- **"Send to Nearby Hospital" Button**: Added at the top of the checkup report screen
  - Prominent red/urgent styling
  - Multilingual support (English, Hindi, Marathi)
  - Icon: `Icons.local_hospital_rounded`

### 2. Location Services
- Integrated `geolocator` package (v10.1.0)
- GPS coordinate retrieval with permission handling
- Location service availability checks
- User-friendly error messages for location issues

### 3. Hospital Finding Logic
- Haversine distance formula implementation for accurate distance calculation
- Queries Supabase `hospitals` table
- Sorts hospitals by distance
- Returns nearest hospital

### 4. Confirmation Dialog
- Shows hospital name and distance before sending
- Format: "Sending to: [Hospital Name] ([X.X km away]). Confirm?"
- User can cancel or confirm the alert

### 5. Alert Data Preparation
- Extracts patient information from user profile:
  - Name, age, gender
  - GPS coordinates
  - Google Maps link
- Determines primary finding from test results:
  - Facial asymmetry (Critical)
  - Speech impairment (Critical/High)
  - Arm drift (High)
  - Coordination deficit (Medium)
- Calculates risk level based on test results

### 6. WhatsApp Message Format
```
🚨 *URGENT PATIENT ALERT*

*Name:* [patient_name], [age]/[gender]
*Location:* https://maps.google.com/?q=[lat],[lng]
*Condition:* [primary_finding]
*Risk:* [risk_level]
*Time:* [timestamp]

Full report is being dispatched. Please prepare.
```

### 7. Logging
- Inserts records into `alert_logs` table with:
  - patient_id
  - hospital_id
  - sent_at timestamp
  - status (sent/failed)
  - message_preview

### 8. User Feedback
- Loading indicators during each step
- Success/failure toast messages
- Multilingual error messages

### 9. Localization
Added strings in English, Hindi, and Marathi:
- `hospital_sendToNearby`
- `hospital_finding`
- `hospital_confirmTitle`
- `hospital_confirmMessage`
- `hospital_confirm`
- `hospital_cancel`
- `hospital_sending`
- `hospital_sent`
- `hospital_failed`
- `hospital_noNearby`
- `hospital_locationError`

## 🔧 Required Backend Setup

### 1. Supabase Database Tables

#### `hospitals` Table
```sql
CREATE TABLE hospitals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  whatsapp_number TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add some sample hospitals
INSERT INTO hospitals (name, whatsapp_number, latitude, longitude, address) VALUES
('City Hospital', '+917738532062', 19.0760, 72.8777, 'Mumbai, Maharashtra'),
('Emergency Care Center', '+919876543210', 19.0896, 72.8656, 'Mumbai, Maharashtra');
```

#### `alert_logs` Table
```sql
CREATE TABLE alert_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES auth.users(id),
  hospital_id UUID REFERENCES hospitals(id),
  sent_at TIMESTAMP WITH TIME ZONE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('sent', 'failed')),
  message_preview TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2. Supabase Edge Function: `send-hospital-alert`

Create a new Edge Function at `supabase/functions/send-hospital-alert/index.ts`:

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const TWILIO_ACCOUNT_SID = Deno.env.get('TWILIO_ACCOUNT_SID')!
const TWILIO_AUTH_TOKEN = Deno.env.get('TWILIO_AUTH_TOKEN')!
const TWILIO_WHATSAPP_FROM = Deno.env.get('TWILIO_WHATSAPP_FROM')!

serve(async (req) => {
  try {
    const {
      hospital_whatsapp_number,
      patient_name,
      age,
      gender,
      gps_coordinates,
      maps_link,
      primary_finding,
      risk_level,
      alert_timestamp,
      message
    } = await req.json()

    // Send WhatsApp message via Twilio
    const twilioUrl = `https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json`
    
    const formData = new URLSearchParams()
    formData.append('To', `whatsapp:${hospital_whatsapp_number}`)
    formData.append('From', TWILIO_WHATSAPP_FROM)
    formData.append('Body', message)

    const response = await fetch(twilioUrl, {
      method: 'POST',
      headers: {
        'Authorization': 'Basic ' + btoa(`${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}`),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formData
    })

    if (!response.ok) {
      const error = await response.text()
      throw new Error(`Twilio API error: ${error}`)
    }

    const result = await response.json()

    return new Response(
      JSON.stringify({ success: true, message_sid: result.sid }),
      { headers: { "Content-Type": "application/json" } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    )
  }
})
```


### 4. Deploy Edge Function
```bash
supabase functions deploy send-hospital-alert
```

## 📝 Additional Notes

### Twilio WhatsApp Setup
1. Sign up for Twilio account
2. Enable WhatsApp messaging
3. Get your Auth Token from Twilio Console
4. Replace `YOUR_AUTH_TOKEN_HERE` in `.env` file
5. Verify the WhatsApp sender number (+14155238886) is approved

### Testing
1. Ensure location permissions are granted on device
2. Add test hospitals to the database with valid coordinates
3. Complete a full checkup with abnormal results
4. Click "Send to Nearby Hospital" button
5. Verify WhatsApp message is received at hospital number

### Future Enhancements
- SMS fallback if WhatsApp fails
- Support for hospitals beyond 50km with warning
- Retry mechanism for failed alerts
- Real-time alert status tracking
- Hospital acknowledgment system

## 🔐 Security Considerations
- Auth token should never be committed to version control
- Use Supabase RLS policies to restrict alert_logs access
- Validate hospital phone numbers before sending
- Rate limit alert sending to prevent abuse
- Encrypt sensitive patient data in transit
