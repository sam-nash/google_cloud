# Cloud Key Management Service

Cloud Key Management Service allows you to create, import, and manage cryptographic keys and perform cryptographic operations in a single centralized cloud service. You can use these keys and perform these operations by using Cloud KMS directly, by using Cloud HSM or Cloud External Key Manager, or by using Customer-Managed Encryption Keys (CMEK) integrations within other Google Cloud services.

## Key Rings

A key ring organizes keys in a specific Google Cloud location and lets you manage access control on groups of keys. A key ring's name does not need to be unique across a Google Cloud project, but must be unique within a given location. After creation, a key ring cannot be deleted. Key rings don't incur any costs.

## Key

A Cloud KMS key is a named object containing one or more key versions, along with metadata for the key. A key exists on exactly one key ring tied to a specific location.

You can allow and deny access to keys using Identity and Access Management (IAM) permissions and roles. You can't manage access to a key version.

Disabling or destroying a key also disables or destroys each key version.
