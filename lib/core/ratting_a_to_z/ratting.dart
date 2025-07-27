import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';

void main() => runApp(const MaterialApp(home: RatingPage()));

class TakeRating extends StatefulWidget {
  final void Function(double) onRatingSelected;

  const TakeRating({super.key, required this.onRatingSelected});

  @override
  _TakeRatingState createState() => _TakeRatingState();
}

class _TakeRatingState extends State<TakeRating> {
  double selectedRating = 0.0;

  void _updateRating(Offset localPosition, double width) {
    final starWidth = width / 10;
    double rawRating = localPosition.dx / starWidth;

    // Clamp rating between 0.5 and 10.0
    double newRating = (rawRating * 2).round() / 2;
    newRating = newRating.clamp(0.5, 10.0);

    setState(() {
      selectedRating = newRating;
    });
    widget.onRatingSelected(selectedRating);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanDown: (details) {
            _updateRating(details.localPosition, constraints.maxWidth);
          },
          onPanUpdate: (details) {
            _updateRating(details.localPosition, constraints.maxWidth);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(10, (index) {
              double fullStarValue = (index + 1).toDouble();
              IconData icon;

              if (selectedRating >= fullStarValue) {
                icon = Icons.star;
              } else if (selectedRating >= fullStarValue - 0.5) {
                icon = Icons.star_half;
              } else {
                icon = Icons.star_border;
              }

              return Icon(icon, color: Colors.yellow, size: 32);
            }),
          ),
        );
      },
    );
  }
}

// class TakeRating extends StatefulWidget {
//   final void Function(double) onRatingSelected;

//   const TakeRating({super.key, required this.onRatingSelected});

//   @override
//   _TakeRatingState createState() => _TakeRatingState();
// }

// class _TakeRatingState extends State<TakeRating> {
//   double selectedRating = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(10, (index) {
//         double fullStarValue = (index + 1).toDouble();

//         return GestureDetector(
//           onTapDown: (details) {
//             final box = context.findRenderObject() as RenderBox;
//             final localPosition = box.globalToLocal(details.globalPosition);

//             final starWidth = box.size.width / 10;
//             final tappedHalf = (localPosition.dx % starWidth) < (starWidth / 2);

//             setState(() {
//               selectedRating = index + (tappedHalf ? 0.5 : 1.0);
//             });

//             widget.onRatingSelected(selectedRating);
//           },
//           child: _buildStar(index),
//         );
//       }),
//     );
//   }

//   Widget _buildStar(int index) {
//     double starRating = index + 1.0;
//     IconData icon;

//     if (selectedRating >= starRating) {
//       icon = Icons.star;
//     } else if (selectedRating >= starRating - 0.5) {
//       icon = Icons.star_half;
//     } else {
//       icon = Icons.star_border;
//     }

//     return Icon(icon, color: Colors.yellow, size: 36);
//   }
// }

class ShowRating extends StatelessWidget {
  final double rating;
  final double iconSize;

  const ShowRating({
    super.key,
    required this.rating,
    //....................... default iconSize........................
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    assert(rating >= 0 && rating <= 10, 'Rating must be between 0 and 10');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index) {
        double currentStar = index + 1;
        if (rating >= currentStar) {
          return Icon(
            Icons.star,
            color: Colors.yellow,
            shadows: [Shadow(blurRadius: 5, color: Colors.red)],
            size: iconSize,
          );
        } else if (rating + 0.5 >= currentStar) {
          return Icon(
            Icons.star_half_outlined,
            color: Colors.yellow,
            shadows: [Shadow(blurRadius: 5, color: Colors.blueGrey.shade400)],
            size: iconSize,
            //20,
          );
        } else {
          return Icon(
            Icons.star_border_outlined,
            color: AppColors.context(context).starIconColor,
            size: iconSize,
          );
        }
      }),
    );
  }
}

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  List<double> ratingsList = [];

  void addRating(double rating) {
    setState(() {
      ratingsList.add(rating);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take and Show Ratings'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TakeRating(
              onRatingSelected: (rating) {
                addRating(rating);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  ratingsList.isEmpty
                      ? const Center(
                        child: Text(
                          'No ratings yet!',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : ListView.builder(
                        itemCount: ratingsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              'Rating ${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            title: ShowRating(rating: ratingsList[index]),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
