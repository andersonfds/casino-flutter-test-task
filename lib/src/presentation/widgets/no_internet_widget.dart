import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/server_down.svg',
                fit: BoxFit.fitWidth,
                height: 120,
              ),
              SizedBox(height: 20),
              Text(
                'Sorry, we could not load the data',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Connect to the internet and we will try again ;-)',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: onRetry,
                label: Text('Retry'),
                icon: Icon(Icons.refresh_rounded),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
