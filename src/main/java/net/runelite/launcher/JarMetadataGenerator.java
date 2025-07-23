package net.runelite.launcher;

import java.io.*;
import java.nio.file.*;
import java.security.*;
import java.util.*;

public class JarMetadataGenerator {
    public static void main(String[] args) throws Exception {
        // Directory containing your JARs (optionally pass as first arg)
        String dirPath = args.length > 0
            ? args[0]
            : "C:\\Users\\SandstormVelh\\Desktop\\VelheimT_lib";

        // Base URL for your libs
        String baseUrl = "https://www.velheim.com/resources/files/libs/";

        Path dir = Paths.get(dirPath);
        if (!Files.isDirectory(dir)) {
            System.err.println("Not a directory: " + dirPath);
            System.exit(1);
        }

        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        List<String> entries = new ArrayList<>();

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(dir, "*.jar")) {
            for (Path jarPath : stream) {
                // File size
                long size = Files.size(jarPath);

                // SHA-256 hash
                digest.reset();
                try (InputStream is = Files.newInputStream(jarPath);
                     DigestInputStream dis = new DigestInputStream(is, digest)) {
                    byte[] buffer = new byte[8192];
                    while (dis.read(buffer) != -1) {
                        // just read to update the digest
                    }
                }
                byte[] hashBytes = digest.digest();
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) {
                    sb.append(String.format("%02x", b));
                }
                String hash = sb.toString();

                // Build JSON object for this JAR
                String jarName = jarPath.getFileName().toString();
                String url    = baseUrl + jarName;
                String jsonObj = String.format(
                    "  {\"name\": \"%s\", \"hash\": \"%s\", \"size\": %d, \"path\": \"%s\"}",
                    jarName, hash, size, url
                );
                entries.add(jsonObj);
            }
        }

        // Print JSON array
        System.out.println("[");
        System.out.println(String.join(",\n", entries));
        System.out.println("]");
    }
}
