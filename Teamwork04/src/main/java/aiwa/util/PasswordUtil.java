package aiwa.util;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

	public static String hashPassword(String password)
			throws Exception {

		byte[] salt = new byte[16];
		new SecureRandom().nextBytes(salt);

		KeySpec spec = new PBEKeySpec(
				password.toCharArray(),
				salt,
				120000,
				256);

		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

		byte[] hash = factory.generateSecret(spec).getEncoded();

		return "PBKDF2$120000$"
				+ Base64.getEncoder().encodeToString(salt)
				+ "$"
				+ Base64.getEncoder().encodeToString(hash);
	}

	public static boolean verifyPassword(String password,
			String storedHash) throws Exception {

		String[] parts = storedHash.split("\\$");

		if (parts.length != 4) {
			return false;
		}

		if (!parts[0].equals("PBKDF2")) {
			return false;
		}

		int iterations = Integer.parseInt(parts[1]);

		byte[] salt = Base64.getDecoder().decode(parts[2]);

		byte[] originalHash = Base64.getDecoder().decode(parts[3]);

		KeySpec spec = new PBEKeySpec(
				password.toCharArray(),
				salt,
				iterations,
				originalHash.length * 8);

		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

		byte[] newHash = factory.generateSecret(spec).getEncoded();

		return java.security.MessageDigest.isEqual(
				originalHash, newHash);
	}
}
