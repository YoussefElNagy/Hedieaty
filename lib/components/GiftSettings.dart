import 'package:flutter/material.dart';
import 'package:hedeyeti/data/gifts.dart'; // Assuming this imports the Gift model and related data.

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

  @override
  void initState() {
    super.initState();
    _giftNameController = TextEditingController(text: widget.gift.giftName);
    _giftDescriptionController = TextEditingController(text: widget.gift.description);
    _giftPriceController = TextEditingController(text: widget.gift.price.toString());
    _selectedCategory = widget.gift.category.name; // Enum to string conversion for category.
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gift Name Field
              TextField(
                controller: _giftNameController,
                decoration: const InputDecoration(
                  labelText: 'Gift Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextField(
                controller: _giftDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Price Field
              TextField(
                controller: _giftPriceController,
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
                  child: Text(category.name),
                ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Image Display
              if (widget.gift.image != null)
                Center(
                  child: Image.network(
                    widget.gift.image!,
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
                  style: TextStyle(color: theme.colorScheme.onPrimary,fontSize: 18,fontWeight: FontWeight.bold),
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
                child: const Text('Delete Gift',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    final updatedGift = widget.gift.copyWith(
      giftName: _giftNameController.text,
      description: _giftDescriptionController.text,
      price: double.tryParse(_giftPriceController.text) ?? 0.0,
      category: GiftCategory.values.firstWhere((cat) => cat.name == _selectedCategory),
    );

    // Add your logic to save the updated gift details (e.g., update database or state)
    print('Gift updated: ${updatedGift.giftName}, ${updatedGift.price}');
    Navigator.pop(context, updatedGift); // Return updated gift.
  }

  void _deleteGift() {
    // Add your logic to delete the gift (e.g., update database or state)
    print('Gift deleted: ${widget.gift.id}');
    Navigator.pop(context, null); // Return null to indicate deletion.
  }
}
