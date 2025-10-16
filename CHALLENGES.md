**Challenges and Resolutions**

During the completion of this project, several challenges were encountered and addressed:

Terraform Module Versioning: Misalignment between Terraform CLI version and module argument names caused repeated 'unsupported argument' errors. 
**Resolution**: Carefully pinning module version (v21.4.0) and adapting code with correct arguments.

Backend Configuration Issues: Initial confusion with S3 backend state bucket requiring manual creation and configuration. 
**Resolution**: Created S3 bucket with versioning and updated backend configuration accordingly.

Resource Naming Consistency: Multiple errors from inconsistent naming of AWS resources (e.g., VPC, subnets) across Terraform files. 
**Resolution**: Enforced strict naming conventions and validated all references.

Deprecated Functions: Encountered errors related to deprecated Terraform functions like list(). 
**Resolution**: Upgraded Terraform CLI and modules to latest versions supporting current syntax.

Cache and Lockfile Conflicts: Old .terraform cache and .terraform.lock.hcl files caused module version conflicts. 
**Resolution**: Regular cleanup of cached files and forced terraform init -upgrade.


CI/CD Validation: Rigorous testing of pipeline triggers and deployment order had to be iterated to avoid state conflicts and ensure idempotency.

These learnings have strengthened the ability to manage real-world infrastructure with Terraform and maintain automated delivery pipelines.
