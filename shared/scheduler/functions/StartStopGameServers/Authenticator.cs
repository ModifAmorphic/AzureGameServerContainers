using Azure.Identity;
using Azure.ResourceManager;
using Microsoft.AspNetCore.Http;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Crypto.Signers;
using Org.BouncyCastle.Utilities.Encoders;
using System;
using System.Text;

namespace GameServers.Scheduler
{
    internal static class Authenticator
    {
        public static ArmClient GetClient() => new ArmClient(new DefaultAzureCredential());

        public static bool VerifySignatureAsync(IHeaderDictionary headers, string body)
        {
            if (!headers.TryGetValue("X-Signature-Ed25519", out var signature)
                || !headers.TryGetValue("X-Signature-Timestamp", out var timestamp))
            {
                return false;
            }

            var publicKeyParam = new Ed25519PublicKeyParameters(Hex.DecodeStrict(Environment.GetEnvironmentVariable("DiscordStartServerAppKey", EnvironmentVariableTarget.Process)));
            var dataToVerifyBytes = Encoding.UTF8.GetBytes(timestamp + body);
            var signatureBytes = Convert.FromHexString(signature);

            var verifier = new Ed25519Signer();
            verifier.Init(false, publicKeyParam);
            verifier.BlockUpdate(dataToVerifyBytes, 0, dataToVerifyBytes.Length);
            return verifier.VerifySignature(signatureBytes);
        }
    }
}