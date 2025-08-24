import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uploadassignmentapplication/model/assignment.dart';
import 'package:uploadassignmentapplication/service/apiService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  List<Assignment> assignments = [];
  bool isLoading = false;
  final TextEditingController assignmentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  /// Fetch assignments from the server
  Future<void> fetchAssignments() async {
    setState(() => isLoading = true);
    try {
      final res = await apiService.getAssignments();
      if (res.success && res.data != null) {
        setState(() {
          assignments =
              (res.data as List)
                  .map<Assignment>((a) => Assignment.fromJson(a))
                  .toList();
        });
      } else {
        _showErrorSnackBar(res.message ?? "Failed to load assignments");
      }
    } catch (e) {
      _showErrorSnackBar("An error occurred: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Pick a file and upload it
  Future<void> uploadFile() async {
    // Validate the form before proceeding
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final assignmentName = assignmentcontroller.text;

      setState(() => isLoading = true);
      try {
        final res = await apiService.uploadAssignment(assignmentName, filePath);
        if (res.success) {
          _showSuccessSnackBar("Upload successful");
          assignmentcontroller.clear();
          fetchAssignments(); // Refresh list
        } else {
          _showErrorSnackBar(res.message ?? "Upload failed");
        }
      } catch (e) {
        _showErrorSnackBar("An error occurred during upload: ${e.toString()}");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  /// Download file and save to local directory
  Future<void> downloadFile(String url, String title) async {
    setState(() => isLoading = true);

    try {
      // Determine the save path based on the platform
      String savePath;
      final String fileName = "$title${path.extension(url)}";

      if (Platform.isWindows) {
        final downloadsDir = await getDownloadsDirectory();
        savePath = path.join(downloadsDir!.path, fileName);
      } else {
        // For macOS, Linux, etc.
        final dir = await getApplicationDocumentsDirectory();
        savePath = path.join(dir.path, fileName);
      }

      final res = await apiService.downloadFile(url, savePath);
      _showSuccessSnackBar(res.message ?? "Downloaded to $savePath");
    } catch (e) {
      _showErrorSnackBar("Download failed: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Helper methods for showing snackbars
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the primary color for reuse
    final Color primaryColor = Colors.blue.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Assignment Portal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- UPLOAD SECTION ---
            _buildUploadCard(primaryColor),
            const SizedBox(height: 16),

            // --- PROGRESS INDICATOR ---
            if (isLoading)
              const LinearProgressIndicator()
            else // Use a placeholder to prevent layout shifts
              Container(height: 4),

            const SizedBox(height: 16),

            // --- ASSIGNMENTS LIST ---
            Text(
              "Submitted Assignments",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            Expanded(
              child:
                  assignments.isEmpty && !isLoading
                      ? _buildEmptyState()
                      : _buildAssignmentsList(primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the card for the upload section
  Widget _buildUploadCard(Color primaryColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: assignmentcontroller,
                  decoration: InputDecoration(
                    labelText: "New Assignment Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an assignment title";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: isLoading ? null : uploadFile,
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the placeholder shown when the assignment list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No assignments found",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const Text(
            "Upload a new assignment to get started.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Builds the list of submitted assignments
  Widget _buildAssignmentsList(Color primaryColor) {
    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            leading: Icon(Icons.assignment, color: primaryColor, size: 40),
            title: Text(
              assignment.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            // The subtitle showing the URL is removed for a cleaner look
            trailing: IconButton(
              icon: Icon(Icons.download, color: primaryColor),
              tooltip: "Download Assignment",
              onPressed:
                  isLoading
                      ? null
                      : () =>
                          downloadFile(assignment.fileUrl, assignment.title),
            ),
          ),
        );
      },
    );
  }
}
