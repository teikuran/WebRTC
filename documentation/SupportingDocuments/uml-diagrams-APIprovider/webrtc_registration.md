# 3.2. WebRTC Registration

This part of the call flow covers WebRTC registration.

## 3.2.1. WebRTC Registrations

### 3.2.1.1. Sequence

```mermaid
sequenceDiagram

    box Device
        participant DA as Device<br/>Application
    end

    box Application Service Provider
        participant AS as Application<br/>Server
    end

    box Operator Network
        participant AUTH as Auth<br/>Server
        participant WG as WebRTC<br/>Gateway
        participant TN as Telco<br/>Network
    end

    box Device
        participant RE as Remote<br/>Endpoint
    end

    activate DA

    AS->>AUTH: [1] GET /authorize

    AUTH-->>AS: [2] 302 Found<br/>(redirecting user agent)

    Note over DA,AUTH: [3] End user consent (e.g. ICM Auth Code Flow)

    AS->>AUTH: [4] POST /token

    AUTH-->>AS: [5] 200 OK

    AS->>WG: [6] POST /webrtc-registration/{apiVersion}/sessions
    activate WG

    WG->>AUTH: [7] POST /token/introspection

    AUTH-->>WG: [8] 200 OK

    WG-->>AS: [9] 200 OK
    deactivate WG

    deactivate DA
```

### 3.2.1.2. Example messages

#### [6] POST /webrtc-registration/{apiVersion}/sessions

```http
POST /webrtc-registration/{apiVersion}/sessions HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-ef1234567890

{
  "deviceId": "7d444840-9dc0-11d1-b245-5ffdce74fad2",
  "registrationExpireTime": "2025-12-31T23:59:59.999Z"
}
```

> **NOTE**
>
> Depending on the WebRTC registration, SIP REGISTER may either be omitted or performed:
>
> - When the Telco network assigns specific phone number ranges to the WebRTC Gateway and accepts SIP INVITE for call routing, SIP REGISTER is omitted.
> - When a SIP account is issued for each phone number used for interworking from WebRTC, SIP REGISTER is performed.
>
> Even when SIP REGISTER is performed, it should be noted that the WebRTC Gateway does not have a SIM and therefore cannot use AKA′ authentication, making it different from IMS UE Registration.

#### [9] 200 OK

```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: a1b2c3d4-e5f6-7890-abcd-ef1234567890

{
  "registrationId": "reg-12345678-abcd-ef90-1234-567890abcdef",
  "regInfo": {
    "phoneNumber": "+123456789",
    "regStatus": "Registered"
  },
  "expiresAt": "2025-12-31T23:59:59.999Z"
}
```

> **NOTE**
>
> The API Provider may define minimum, maximum, and default values for the WebRTC registration validity period. If the requested duration ("registrationExpireTime" - currentTime) is within the acceptable range, 'expiredAt' may be set to the requested value.
>
> Otherwise, the API Provider may either use (currentTime + default value) for 'expiredAt' or return an error.

## 3.2.2. Refresh WebRTC Registrations

### 3.2.2.1. Sequence

```mermaid
sequenceDiagram

    box Device
        participant DA as Device<br/>Application
    end

    box Application Service Provider
        participant AS as Application<br/>Server
    end

    box Operator Network
        participant AUTH as Auth<br/>Server
        participant WG as WebRTC<br/>Gateway
        participant TN as Telco<br/>Network
    end

    box Device
        participant RE as Remote<br/>Endpoint
    end

    activate DA

    AS->>AUTH: [10] GET /authorize

    AUTH-->>AS: [11] 302 Found<br/>(redirecting user agent)

    Note over DA,AUTH: [12] End user consent (e.g. ICM Auth Code Flow)

    AS->>AUTH: [13] POST /token

    AUTH-->>AS: [14] 200 OK

    AS->>WG: [15] PUT /webrtc-registration/{apiVersion}/sessions/{registrationId}
    activate WG

    WG->>AUTH: [16] POST /token/introspection

    AUTH-->>WG: [17] 200 OK

    WG-->>AS: [18] 200 OK
    deactivate WG

    deactivate DA
```

### 3.2.2.2. Example messages

#### [15] PUT /webrtc-registration/{apiVersion}/sessions/{registrationId}

```http
PUT /webrtc-registration/{apiVersion}/sessions/reg-12345678-abcd-ef90-1234-567890abcdef HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-f23456789012

{
  "registrationExpireTime": "2026-01-15T12:00:00.000Z"
}
```

#### [18] 200 OK

```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: b2c3d4e5-f6a7-8901-bcde-f23456789012

{
  "regInfo": {
    "phoneNumber": "+123456789",
    "regStatus": "Registered"
  },
  "registrationId": "reg-12345678-abcd-ef90-1234-567890abcdef",
  "expiresAt": "2026-01-15T12:00:00.000Z"
}
```

## 3.2.3. WebRTC De-Registrations

### 3.2.3.1. Sequence

```mermaid
sequenceDiagram

    box Device
        participant DA as Device<br/>Application
    end

    box Application Service Provider
        participant AS as Application<br/>Server
    end

    box Operator Network
        participant AUTH as Auth<br/>Server
        participant WG as WebRTC<br/>Gateway
        participant TN as Telco<br/>Network
    end

    box Device
        participant RE as Remote<br/>Endpoint
    end

    activate DA

    AS->>AUTH: [19] GET /authorize

    AUTH-->>AS: [20] 302 Found<br/>(redirecting user agent)

    Note over DA,AUTH: [21] End user consent (e.g. ICM Auth Code Flow)

    AS->>AUTH: [22] POST /token

    AUTH-->>AS: [23] 200 OK

    AS->>WG: [24] DELETE /webrtc-registration/{apiVersion}/sessions/{registrationId}
    activate WG

    WG->>AUTH: [25] POST /token/introspection

    AUTH-->>WG: [26] 200 OK

    WG-->>AS: [27] 204 No Content
    deactivate WG

    deactivate DA
```

### 3.2.3.2. Example messages

#### [24] DELETE /webrtc-registration/{apiVersion}/sessions/{registrationId}

```http
DELETE /webrtc-registration/{apiVersion}/sessions/reg-12345678-abcd-ef90-1234-567890abcdef HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: c3d4e5f6-a7b8-9012-cdef-345678901234
```

#### [27] 204 No Content

```http
HTTP/1.1 204 No Content
x-correlator: c3d4e5f6-a7b8-9012-cdef-345678901234
```
