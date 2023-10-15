import 'package:flutter/material.dart';

class BabyCard extends StatelessWidget {
  final String name;
  final String gender;
  final String birth;
  final String description;

  const BabyCard({
    required this.name,
    required this.gender,
    required this.birth,
    this.description = "",
    super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.width / 2.5,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Container(
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    birth,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
