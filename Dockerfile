FROM ghcr.io/cirruslabs/flutter:3.32.5

WORKDIR /app

COPY . .

RUN flutter pub get

RUN flutter build apk --release

VOLUME ["/app/build/app/outputs/flutter-apk"]
