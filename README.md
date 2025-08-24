# 🗂️ Assignment Portal — Flutter Desktop App

A cross-platform **desktop** application built with **Flutter** for managing course assignments.  
Teachers can **push (upload/publish)** assignments; students can **view & download** submissions and upload their work.  
Supports **Windows / macOS / Linux**.

![App Preview](https://github.com/user-attachments/assets/your-image-id-here)

> Tip: If you prefer a local image instead of a hosted one, replace the line above with:
> `<img src="assets/readme/cover.png" width="900" alt="Assignment Portal Preview" />`

---

## ✨ Features

- 👩‍🏫 **Instructor Panel**
  - Create/publish assignments with title, description, due date, and attachments
  - Edit/close assignments
  - View submissions and download files

- 🎓 **Student Panel**
  - Browse available assignments
  - Download assignment files
  - Upload submissions (single or multiple attachments)
  - Status & deadline indicators

- 🔐 **Auth (optional)**
  - Email/password based login
  - Role-based UI (Instructor / Student)

- 💾 **File Handling**
  - OS-native file dialogs for upload
  - Safe downloads to user’s Downloads folder
  - Progress bars & retry

- 🌗 **Delightful UI**
  - Responsive desktop-friendly layout
  - Theming (light/dark)

---

## 🖼️ Screenshots

> Replace the links with your own GitHub issue/attachment URLs or local images in `assets/readme/`.

### Dashboard
![Dashboard](https://github.com/user-attachments/assets/your-dashboard-image-id)

### Assignment Details
![Assignment Details](https://github.com/user-attachments/assets/your-details-image-id)

### Upload / Download
<img src="assets/readme/upload-dialog.png" width="700" alt="Upload Dialog" />

---

## 🏗️ Tech Stack

- **Flutter** (Desktop: Windows/macOS/Linux)
- **State Management:** `provider` or `riverpod` (choose one)
- **Networking:** `dio` (download/upload with progress)
- **File Picker:** `file_picker`
- **Path Utils:** `path_provider` (Downloads/Documents)
- **Local Storage:** `shared_preferences` (auth token, preferences)

> Backend-agnostic: Works with any REST API that exposes endpoints for auth, assignments & files. (Django/DRF, Node/Express, etc.)

---

## 🧰 Prerequisites

- Flutter SDK (3.19+ recommended) → https://docs.flutter.dev/get-started/install
- Desktop toolchain set up:
  - **Windows:** Visual Studio w/ C++ Desktop Development workload
  - **macOS:** Xcode + Command Line Tools
  - **Linux:** GTK development libs (`sudo apt install libgtk-3-dev`), etc.
- A running backend API (or mock server)

---

## ⚙️ Configuration

Create a file `.env` (or use a Dart constants file) and set your API base URL:

```env
API_BASE_URL=https://your-backend.example.com/api
DOWNLOAD_DIR=DEFAULT   # DEFAULT uses OS Downloads; or provide an absolute path
