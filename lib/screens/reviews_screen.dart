import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../providers/app_state.dart';

class ReviewsScreen extends StatelessWidget {
  final Product product;
  const ReviewsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // Obtenemos el producto actualizado del estado global
    final currentProduct = app.products.firstWhere(
      (p) => p.id == product.id, 
      orElse: () => product
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Calificaciones y Reseñas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSummary(currentProduct),
            const SizedBox(height: 24),
            const Text('Opiniones de compradores', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            if (currentProduct.reviews.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.rate_review_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Este producto aún no tiene reseñas.', 
                        style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              ...currentProduct.reviews.reversed.map((r) => _buildReviewItem(r, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary(Product p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(p.rating.toStringAsFixed(1), 
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < p.rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber, size: 16,
                )),
              ),
              const SizedBox(height: 4),
              Text('${p.reviews.length} reseñas', style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(5, 0.8), // Datos visuales de ejemplo para las barras
                _buildRatingBar(4, 0.1),
                _buildRatingBar(3, 0.05),
                _buildRatingBar(2, 0.0),
                _buildRatingBar(1, 0.05),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.white,
              color: Colors.amber,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review, BuildContext context) {
    final app = context.read<AppState>();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 18,
                child: Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U', 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(review.date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 14,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment, 
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.verified_user, color: Colors.green, size: 14),
              const SizedBox(width: 4),
              const Text('Compra verificada', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
              const Spacer(),
              InkWell(
                onTap: () => app.toggleReviewLike(review),
                child: Row(
                  children: [
                    Icon(
                      review.isLikedByMe ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 16,
                      color: review.isLikedByMe ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.likes > 0 ? '${review.likes}' : '¿Útil?',
                      style: TextStyle(
                        fontSize: 12,
                        color: review.isLikedByMe ? Colors.blue : Colors.grey,
                        fontWeight: review.isLikedByMe ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
