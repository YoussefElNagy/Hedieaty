import 'package:flutter/material.dart';
import 'package:hedeyeti/components/giftsettings/GiftSettingsVM.dart';
import 'package:hedeyeti/model/gifts.dart'; // Assuming this imports the Gift model and related data.

class GiftSettings extends StatefulWidget {
  final Gift gift;

  const GiftSettings({Key? key, required this.gift}) : super(key: key);

  @override
  State<GiftSettings> createState() => _GiftSettingsState();
}

class _GiftSettingsState extends State<GiftSettings> {
  late TextEditingController _giftNameController;
  late TextEditingController _giftDescriptionController;
  late TextEditingController _giftPriceController;
  late String _selectedCategory;
  bool _isSaving = false; // Flag to track save operation.
  final _formKey = GlobalKey<FormState>(); // Key for the form

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return; // If validation fails, do nothing
    }

    setState(() => _isSaving = true);
    final updatedGift = widget.gift.copyWith(
      giftName: _giftNameController.text,
      description: _giftDescriptionController.text,
      price: int.tryParse(_giftPriceController.text) ?? 0,
      image: GiftSettingsViewModel().categoryImages[_selectedCategory] ?? 'assets/other.jpg',
      category: GiftCategory.values
          .firstWhere((cat) => cat.name == _selectedCategory),
    );
    try {
      await GiftSettingsViewModel().updateGift(updatedGift);
      Navigator.pop(context,true);
    } catch (e) {
      // Handle error (you could show a snackbar or an error message)
      print("Error updating gift: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating gift: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _deleteGift() async {
    try {
      await GiftSettingsViewModel().deleteCurrentGift(widget.gift);
      Navigator.pop(context,true);
    } catch (e) {
      // Handle error (you could show a snackbar or an error message)
      print("Error deleting gift: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting gift: ${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _giftNameController = TextEditingController(text: widget.gift.giftName);
    _giftDescriptionController =
        TextEditingController(text: widget.gift.description);
    _giftPriceController =
        TextEditingController(text: widget.gift.price.toString());
    _selectedCategory = widget.gift.category.name
        .toString(); // Enum to string conversion for category.
  }

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftDescriptionController.dispose();
    _giftPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hedieaty',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: _isSaving
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gift Name Field
                      TextFormField(
                        controller: _giftNameController,
                        validator: GiftSettingsViewModel().validateGiftName,
                        decoration: const InputDecoration(
                          labelText: 'Gift Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Field
                      TextFormField(
                        controller: _giftDescriptionController,
                        validator:
                            GiftSettingsViewModel().validateGiftDescription,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Price Field
                      TextFormField(
                        controller: _giftPriceController,
                        validator: GiftSettingsViewModel().validateGiftPrice,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        items: GiftCategory.values
                            .map((category) => DropdownMenuItem(
                                  value: category.name,
                                  child: Text(
                                    category.toString().split('.').last,
                                  ),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Image Display
                      Center(
                        child: Image.asset(
                          GiftSettingsViewModel().categoryImages[_selectedCategory]!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Save Changes Button
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Delete Gift Button
                      ElevatedButton(
                        onPressed: _deleteGift,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: theme.colorScheme.surface,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Delete Gift',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
