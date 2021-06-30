import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';
import '../providers/product.dart';

class EditScreen extends StatefulWidget {
  static const routeName = "/edit-screen";
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _initState = false;
  var _isLoading = false;
  var _product =
      Product(id: "", name: "", description: "", price: -1, imageURL: "");

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_initState) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        _product = Provider.of<Products>(context, listen: false)
            .productWith(id: productId);
        _imageUrlController.text = _product.imageURL;
      }
    }
    _initState = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.removeListener(_updateImageURL);
    _imageFocusNode.dispose();

    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _submit() {
    final isValid = _form.currentState!.validate();
    setState(() {
      _isLoading = true;
    });

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Provider.of<Products>(context, listen: false)
        .addProduct(_product)
        .then((_) => Navigator.of(context).pop())
        .catchError((error) {
      Navigator.of(context).pop(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(onPressed: _submit, icon: Icon(Icons.save_rounded))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _product.name,
                      decoration: InputDecoration(labelText: "Name"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _product = Product(
                            id: _product.id,
                            name: value!,
                            description: _product.description,
                            price: _product.price,
                            imageURL: _product.imageURL);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter a title';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue:
                          _product.price < 0 ? "" : _product.price.toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _product = Product(
                            id: _product.id,
                            name: _product.name,
                            description: _product.description,
                            price: double.parse(value!),
                            imageURL: _product.imageURL);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter a title';
                        if (double.tryParse(value) == null)
                          return 'Only numbers are accepted in price field';
                        if (double.parse(value) < 0)
                          return "Price can't be a negative value";
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _product.description,
                      decoration: InputDecoration(labelText: "Description"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _product = Product(
                            id: _product.id,
                            name: _product.name,
                            description: value!,
                            price: _product.price,
                            imageURL: _product.imageURL);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Description is required. Please provide one";
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'Enter url',
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.contain,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image url"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) => _submit(),
                            onSaved: (value) {
                              _product = Product(
                                  id: _product.id,
                                  name: _product.name,
                                  description: _product.description,
                                  price: _product.price,
                                  imageURL: value!);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
