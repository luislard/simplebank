# Authentication

In my years as developer I have use several Authentication tools,
Here we are going to explain a bit some.

## The auth process
![auth_process.png](img%2Fauth_process.png)

## JSON Web Token (JWT)
Structure
![jwt_structure.png](img%2Fjwt_structure.png)

### JWT Signature Algorithms
![signature_algorithms.png](img%2Fsignature_algorithms.png)

### JWT Issues

Summary:
- Use symmetric digital signature algorithm only if your service is internal
- Use Asymmetric digital signature algorithm if your API is public
- In the process of verifying the token CHECK algorithm type to avoid security issue explained below
  ![jwt_issues.png](img%2Fjwt_issues.png)

## Platform-Agnostic SEcurity TOkens (PASETO)
![paseto_explained.png](img%2Fpaseto_explained.png)

## PASETO structure
![paseto_structure.png](img%2Fpaseto_structure.png)