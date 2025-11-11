### Create the helm chart

You will start by generating a new Helm chart structure that will serve as the foundation for the database application.

Requirements:

- Create a new Helm chart named `database-app.`
- Open the file **Chart.yaml** and modify its metadata as follows:
  - Set the **description** field to: `A Helm chart for deploying a database application.`
  - Update the **appVersion** to `1.0.0`
  - Ensure the chart **version** is set to `0.1.0`

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create a new Helm chart named 'database-app'
helm create database-app

# Navigate into the chart directory
cd database-app

# We open the chart.yaml using vim
vim chart.yaml

# Update the chart metadata using the values provided above
apiVersion: v2
name: database-app
description: A Helm chart for deploying a database application.
type: application
version: 0.1.0
appVersion: "1.0.0"
```

</p>
</details>
