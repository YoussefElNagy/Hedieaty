import 'package:flutter/material.dart';
import 'package:hedeyeti/components/addgift/AddGiftVM.dart';
import '../../model/events.dart';
import '../../model/gifts.dart';

class AddGiftPage extends StatefulWidget {
  final Event event;

  const AddGiftPage({Key? key, required this.event}) : super(key: key);

  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final _giftNameController = TextEditingController();
  final _giftDescriptionController = TextEditingController();
  final _giftPriceController = TextEditingController();
  late String _selectedCategory;
  bool _isSaving = false; // Track save operation.
  final _formKey = GlobalKey<FormState>();

  final AddGiftViewModel _viewModel = AddGiftViewModel();

  @override
  void initState() {
    super.initState();
    _selectedCategory = GiftCategory.values.first.name; // Default category
  }

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftDescriptionController.dispose();
    _giftPriceController.dispose();
    super.dispose();
  }

  Future<void> _saveGift() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Fetch the current user
      final currentUser = await _viewModel.fetchCurrentUser();
      if (currentUser == null) throw Exception("User not found");

      // Create gift object
      final giftId = _viewModel.generateGiftId();
      final newGift = Gift(
        id: giftId,
        giftName: _giftNameController.text.trim(),
        description: _giftDescriptionController.text.trim(),
        price: int.parse(_giftPriceController.text.trim()),
        image: _viewModel.categoryImages[_selectedCategory] ?? 'assets/other.jpg',
        ownerId: currentUser.id,
        category: GiftCategory.values.firstWhere(
          (e) => e.name == _selectedCategory,
        ),
        eventId: widget.event.id,
        isPledged: false,
        pledgedById: "",
      );

      // Save gift to database
      await _viewModel.addNewGift(giftId, newGift);

      // Return to previous screen
      if (mounted) {
        Navigator.pop(context,true);
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add gift: $e")),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
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
                        validator: _viewModel.validateGiftName,
                        decoration: const InputDecoration(
                          labelText: 'Gift Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Field
                      TextFormField(
                        controller: _giftDescriptionController,
                        validator: _viewModel.validateGiftDescription,
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
                        validator: _viewModel.validateGiftPrice,
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

                      // Image Display

                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            _viewModel.categoryImages[_selectedCategory]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 20),


                      // Save Changes Button
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveGift,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Add Gift',
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
