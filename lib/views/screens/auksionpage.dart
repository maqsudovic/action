import 'package:auksion_app/controllers/productcontroller.dart';
import 'package:auksion_app/views/widgets/aboutphot.dart';
import 'package:flutter/material.dart';

class Auksionpage extends StatefulWidget {
  final product;
  final id;
  const Auksionpage({super.key, required this.product, required this.id});

  @override
  State<Auksionpage> createState() => _AuksionpageState();
}

class _AuksionpageState extends State<Auksionpage> {
  final TextEditingController pricecontroller = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final List<dynamic> prices = [];
  final ProductController productcontroller = ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 300, child: Aboutphot(product: widget.product)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Hozirgi narhi: ${widget.product.startprice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: pricecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ma`lumot tog`ri kirg`izing!";
                        }
                        int? inputPrice = int.tryParse(value);
                        if (inputPrice == null ||
                            inputPrice <= widget.product.startprice) {
                          return 'Mahsulotni tan narhidan baland narh kirg`izng !';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.monetization_on),
                        labelText: 'O`z stavkangizni kiritng!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          int newPrice = int.parse(pricecontroller.text);
                          try {
                            await productcontroller.updatePrice(
                                newPrice,
                                widget.product.name,
                                widget.product.categoryname);
                            setState(() {
                              prices.add(newPrice);
                              widget.product.startprice = newPrice;
                              pricecontroller.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Narh muvaffaqiyatli yangilandi!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Narh yangilanishida xatolik: $e'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Baholash")],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: prices
                          .map((price) => Text(
                                'Narh: $price',
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
