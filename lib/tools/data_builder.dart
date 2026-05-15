import 'package:flutter/material.dart';

class DataBuilder {
  static FutureBuilder<T> futureBuilder<T>({
    required Future<T> future,
    required Widget Function(BuildContext, AsyncSnapshot<T>) builder,
  }) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }
        return builder(context, snapshot);
      },
    );
  }

  static StreamBuilder<T> streamBuilder<T>({
    required Stream<T>? stream,
    required Widget Function(BuildContext, AsyncSnapshot<T>) builder,
  }) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return builder(context, snapshot);
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const Center(child: Text('Stream completed - no data'));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
