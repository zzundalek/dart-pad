# FROM debian:bookworm
FROM debian:trixie-slim

# Install Dependencies.
RUN apt update -y
RUN apt install -y \
git \
wget \
curl \
unzip \
lib32stdc++6 \
libglu1-mesa \
default-jdk-headless \
xz-utils

# https://github.com/GoogleCloudPlatform/cloud-builders-community/blob/master/flutter/Dockerfile

# Install the Android SDK Dependency.
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip"
ENV ANDROID_TOOLS_ROOT="/opt/android_sdk"
RUN mkdir -p "${ANDROID_TOOLS_ROOT}/cmdline-tools"
ENV ANDROID_SDK_ARCHIVE="${ANDROID_TOOLS_ROOT}/archive"
RUN wget -q "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_TOOLS_ROOT}/cmdline-tools" "${ANDROID_SDK_ARCHIVE}"
RUN mv "${ANDROID_TOOLS_ROOT}/cmdline-tools/cmdline-tools" "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest"
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "build-tools;28.0.0"
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "platforms;android-28"
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "platform-tools"
RUN rm "${ANDROID_SDK_ARCHIVE}"
ENV PATH="${ANDROID_TOOLS_ROOT}/cmdline-tools/latest:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin:${PATH}"

# Install Flutter.
ENV FLUTTER_VERSION="3.35.2"
ENV FLUTTER_ROOT="/opt/flutter"
RUN git clone --branch "${FLUTTER_VERSION}" --depth 1 https://github.com/flutter/flutter.git "${FLUTTER_ROOT}"

ENV PATH="${FLUTTER_ROOT}/bin:${PATH}"
ENV ANDROID_HOME="${ANDROID_TOOLS_ROOT}"

# Disable analytics and crash reporting on the builder
RUN flutter config --no-analytics

# Perform an artifact precache so that no extra assets need to be downloaded on demand.
RUN flutter precache

# Accept licenses.
RUN yes "y" | flutter doctor --android-licenses

# Perform a doctor run.
RUN flutter doctor -v

# I should be sure that I don't iclude any build files...
WORKDIR /app
COPY pkgs pkgs
COPY third_party third_party
COPY pubspec.yaml pubspec.yaml

WORKDIR /app/pkgs/dart_services

RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server

RUN dart tool/grind.dart build-project-templates
# RUN dart tool/grind.dart build-storage-artifacts

EXPOSE 8080
CMD ["/app/pkgs/dart_services/bin/server"]
