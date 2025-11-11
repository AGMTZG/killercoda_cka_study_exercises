### Roll back the release to the previous stable version

During the TLS upgrade, you noticed that the provided certificate and key did not match, causing the Nginx pods to fail and preventing the application from starting properly. To quickly restore service availability, you will roll back the Nginx release to the previous stable version without TLS enabled.

After performing the rollback, confirm that the application is running correctly again and that the configuration has returned to its original state.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# List all available revisions of the release
helm history my-nginx-release

# Roll back to the previous stable revision
helm rollback my-nginx-release 1

# Verify that the values were restored
helm get values my-nginx-release
```

</p>
</details>
