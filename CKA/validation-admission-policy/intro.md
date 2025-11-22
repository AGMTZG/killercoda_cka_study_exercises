### Enforce Multi-Label Governance with Conditional Validation

In Kubernetes, ensuring consistent labeling of resources is critical for governance, auditing, and operational visibility. In this scenario, you'll learn how to enforce multi-label governance on Pods using **ValidatingAdmissionPolicy**.

You'll cover:

- Enforcing mandatory labels (`owner` and `env`) across all Pods.
- Conditional labels depending on the app type (`tier` required for web apps).
- Namespace-specific rules (e.g., Pods in `production` must have `env: prod`).
- Creating a `ValidatingAdmissionPolicy` and binding it cluster-wide.
- Testing policy enforcement with valid and invalid Pods.

By the end of this scenario, you will be able to enforce labeling standards automatically and ensure your cluster complies with organizational governance policies.

Press **Next** to start.
