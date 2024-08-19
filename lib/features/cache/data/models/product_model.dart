import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
	final int? id;
	final String? name;
	final String? description;
	final double? price;
	final String? imageUrl;

	const ProductModel({
		this.id, 
		this.name, 
		this.description, 
		this.price, 
		this.imageUrl, 
	});

	factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
				id: json['id'] as int?,
				name: json['name'] as String?,
				description: json['description'] as String?,
				price: (json['price'] as num?)?.toDouble(),
				imageUrl: json['image_url'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'description': description,
				'price': price,
				'image_url': imageUrl,
			};

	@override
	List<Object?> get props => [id, name, description, price, imageUrl];
}
