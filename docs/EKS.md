# EKS

## Cluster Creation
Go to EKS, Create cluster

1. You will need to create a role, stop and create it. See: "Creating the role for accessing the cluster"
2. Then click the refresh button to refresh roles. Select the created role.
3. Then wait until the cluster is created.
4. Add node group, See "Adding Node Groups"



## Creating the role for accessing the cluster
<details>
<summary>Click to see details</summary>

- Go to IAM
- create role
- AWS Service
- Scroll down to the use case
- Click on EKS
- Select EKS - Cluster and go to next page
- Select the Policy "AmazonEKSClusterPolicy" and next
- Select a name for your new Role

![EKSRole.png](img%2FEKSRole.png)
</details>

## Adding Node Groups
<details>
<summary>Click to see details</summary>

- Go to compute tab
- Click add node group
- You need to create a new Role
  - Go to IAM > Roles > Create Role
  - Select AWS Service
  - Select EC2, and next
  - Look for the following policies:
    - AmazonEKS_CNI_Policy
    - AmazonEKSWorkerNodePolicy
    - AmazonEC2ContainerRegistryReadOnly
  - Give the role a name and create it
- Select the created role by refreshing.
- We skip launch template, k8s labels, k8s taints and tags
- Click next
- See Node Group compute configurations

![eks_conf_node_groups_1.png](img%2Feks_conf_node_groups_1.png)
![eks_conf_node_groups_2.png](img%2Feks_conf_node_groups_2.png)
![eks_conf_node_groups_3.png](img%2Feks_conf_node_groups_3.png)
![eks_conf_node_groups_4.png](img%2Feks_conf_node_groups_4.png)
![eks_conf_node_groups_5.png](img%2Feks_conf_node_groups_5.png)
![eks_conf_node_groups_6.png](img%2Feks_conf_node_groups_6.png)
![eks_conf_node_groups_7.png](img%2Feks_conf_node_groups_7.png)
![eks_conf_node_groups_8.png](img%2Feks_conf_node_groups_8.png)
![eks_conf_node_groups_9.png](img%2Feks_conf_node_groups_9.png)
</details>

## Troubleshooting

If you get:
```
 0/1 nodes are available: 1 Too many pods. preemption: 0/1 nodes are available: 1 No preemption victims found for incoming pod.
```
Then, in the following link, there is a link that shows the amount of pods each node type can hold.

In our case we selected t3.micro -> 4 pods and our app was the pod number 5 so it couldnt b deployed.

We switched to t3.small
```
- t3.micro 4
- t3.nano 4
- t3.small 11
```
https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt
