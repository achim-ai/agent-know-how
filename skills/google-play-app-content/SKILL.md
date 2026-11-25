---
name: google-play-app-content
description: Complete Google Play's App content declarations for a new app - which of the ten forms the API can submit (only Data safety), how to submit the Data safety CSV through the Android Publisher API, and how to answer Sign in details, Target audience, Content ratings and the data-type questions without common mistakes. Use when setting up a new Play listing or when App content shows items that need attention.
compatibility: Google Play Console; Android Publisher API v3 with a service account
metadata:
  verified: "2026-11-06"
  verified-with: "Android Publisher API discovery revision 20261105; Data safety submitted for three apps"
---

# Google Play App content

Play's **App content** page has ten declarations: Privacy policy, Ads, Sign in details (formerly App access), Content ratings, Target audience and content, Data safety, Advertising ID, Government apps, Financial features and Health apps. Only **Data safety** can be submitted through the normal publishing API; the other nine are Console-only, and no API reads the overall checklist.

## Steps

1. Inspect the real shipping build first: enabled SDKs, sign-in, purchases, backend, feedback, media and telemetry, including what SDKs and your server send to third parties, not just app permissions.
2. **Data safety:** start from a current CSV schema. If you have none, export one with **Export to CSV** at the top right of the app's Data safety form; old public samples are rejected. Fill in every data type you collect and the handling answers for each.
3. Submit the complete CSV with a service account that has the app's **Manage policy declarations** permission and the `https://www.googleapis.com/auth/androidpublisher` scope:

   ```text
   POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/<package>/dataSafety
   Content-Type: application/json
   {"safetyLabels": "<the complete CSV as one string>"}
   ```

   **HTTP 204 with an empty body means accepted.** There is no read-back or validate-only call. Keep the accepted CSV.
4. Complete the other nine forms in Play Console. **Save** puts changes into **Publishing overview**; they still have to be sent for review. Afterwards check **App content → Needs attention**.

## Check

Data safety returned 204, and **App content → Needs attention** lists nothing for the app.

## Pitfalls

- **Account creation:** a one-time email code counts as "Username and other authentication". Accounts created by an administrator mean "My app does not allow users to create an account" plus Yes to "accounts created outside of the app".
- **Deletion:** answering Yes to data-deletion requests also needs a public **Delete data URL** that explains the steps (`PSL_DATA_DELETION_URL` missing otherwise), even for apps without in-app accounts. Claim "deleted within 90 days" only if it is really enforced.
- **Collected vs shared:** "Collected" is anything sent off the device, even if processed ephemerally. A service provider isn't automatically "shared". Ephemeral means memory-only for the real-time request.
- **SDKs collect too:** an ad SDK can collect approximate location from the IP address without any location permission. Anonymous purchase or install IDs can count as "Device or other IDs" or "User IDs". A purchase provider can process "Purchase history".
- **Sign in details:** reviewers can't create accounts, buy with their own accounts, use trials or contact you. Give steps that reach the whole app, including paid content. Paid content without an app login needs no username or password; leave those fields blank.
- **Target audience:** pick only age groups the app is really designed for; an adult-only rating answer isn't the same as an adult target audience.
- **Content ratings:** the IARC questionnaire generates the ratings; never pick a rating yourself. A rating like Teen can coexist with an 18+ product policy. The rating contact email may be shared with IARC and rating authorities; it is separate from the public listing contact.
- **Advertising ID:** a manifest permission alone isn't the declaration; answer from the merged manifest and the SDKs' real behavior.
- A Data safety submission doesn't complete the other declarations, and a `users.list` permission denial (HTTP 403) doesn't mean Data safety will fail.
- Keep the provider's CRLF line endings and exact labels in the CSV; whitespace linters flag every row.
- The `appstore/{package}/apps:update` endpoint with `policyDeclarations` is only for registered third-party app stores, not normal listings.
