---
name: app-store-privacy-labels
description: Answer App Store Connect's App Privacy questions correctly and keep "Data Linked to You" small - what counts as collected and linked, how common building blocks (feedback, screenshots, analytics IDs, diagnostics, RevenueCat, CloudKit, support email) map to Apple's data types, and design changes that unlink data. Use when filling in or reviewing App Store privacy labels or a PrivacyInfo.xcprivacy manifest.
compatibility: Apple App Store Connect
metadata:
  verified: "2026-10-23"
  verified-with: "Apple's App Privacy details page and RevenueCat's Apple privacy guide, October 2026"
---

# App Store privacy labels

## Steps

1. Apply Apple's rules from [App Privacy details](https://developer.apple.com/app-store/app-privacy-details/):
   - **Collected** means sent off the device and kept readable by you or a third-party SDK longer than needed to answer the request in real time. Data processed only on the device is not collected. Data that Apple collects doesn't count as yours.
   - **Linked** is the default. Data is not linked only when identifiers are removed before collection and you never join it to identifying data.
   - **Optional to disclose:** infrequent, user-initiated feedback or support requests outside the app's main purpose, and opt-in product-improvement programs that meet Apple's conditions.
2. Map each building block:

   | Building block | Apple data type | Linked? |
   | --- | --- | --- |
   | In-app feedback message | User Content → Customer Support | No, unless the same record carries an email, account or purchase ID |
   | Feedback screenshot | User Content → Photos or Videos | Same as the message |
   | Reply email plus purchase customer ID | Contact Info → Email Address; Purchases → Purchase History | Yes |
   | Analytics with a random per-purpose ID | Usage Data → Product Interaction; Identifiers → Device ID | No, while never joined to identifying data |
   | Diagnostics | Diagnostics → Crash, Performance, Other Diagnostic Data | No, while never joined |
   | RevenueCat with its anonymous ID | Purchases → Purchase History | No; yes once the ID reaches you next to an email |
   | CloudKit private or shared database | Not collected: Apple holds it and you can't read it | — |
   | Support email opened in Mail | Contact Info → Email Address; Customer Support | Optional to disclose |
   | HealthKit or camera data processed on the device | Not collected | — |

3. Look for joins: one shared support or installation ID across feedback, analytics and diagnostics makes everything linked as soon as any of them carries an email or purchase ID.
4. Before submitting, build the signed archive and compare its merged privacy report (including SDK manifests such as RevenueCat's) with your answers.

## Check

Every answer matches the signed archive's privacy report, and each linked type has a real join you can name.

## Pitfalls

- Don't declare CloudKit data you can't read; that alone can remove several linked types.
- Random per-purpose IDs never joined to identifying data are not linked; marking them linked over-declares.
- To shrink linked data: keep reward emails and purchase IDs in a separate record without the shared support ID, use a one-time code instead of the purchase customer ID, or use a fresh random reference per incident instead of one installation-wide ID.
- Persistent pseudonymous IDs count as personal data under privacy laws. Declaring them as "not linked" is safer than leaving them out.
- Re-check the answers whenever feedback, analytics, diagnostics or purchase payloads change.
