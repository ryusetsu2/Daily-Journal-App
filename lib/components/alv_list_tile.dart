import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    Key? key,
    required this.activityName,
    required this.userEmail,
    required this.timeStamp,
    required this.onPressed,
    required this.instance,
    required this.description,
    required this.image,
  }) : super(key: key);

  final String activityName;
  final String userEmail;
  final String timeStamp;
  final String description;
  final String image;
  final String instance;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          activityName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description, // Display the description text
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight
                    .normal, // You can adjust the fontWeight as needed
              ),
            ),
            Text(
              instance, // Display the description text
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight
                    .normal, // You can adjust the fontWeight as needed
              ),
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            CachedNetworkImage(
              imageUrl: image, // Display the image from the 'embbedUrl'
              placeholder: (context, url) =>
                  const CircularProgressIndicator(), // Placeholder until the image loads
              errorWidget: (context, url, error) => const Icon(
                  Icons.error), // Widget shown when image fails to load
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
              fit: BoxFit.cover, // Define the fit for the image
            ),
            const SizedBox(height: 5),
            Text(
              "$userEmail $timeStamp",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5)
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 239, 238, 238),
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.delete),
            iconSize: 25,
          ),
        ),
      ),
    );
  }
}
