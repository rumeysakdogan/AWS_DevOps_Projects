# Advanced Demo - CodePipeline

*Project Source*: https://github.com/acantril/learn-cantrill-io-labs/tree/master/aws-codepipeline-catpipeline

In this demo series you're going to be implementing a full code pipeline incorportating commit, build and deploy steps.

The advanced demo consists of 5 stages :-

- STAGE 1 : Configure Security & Create a CodeCommit Repo
- STAGE 2 : Configure CodeBuild to clone the repo, create a container image and store on ECR
- STAGE 3 : Configure a CodePipeline with commit and build steps to automate build on commit.
- STAGE 4 : Create an ECS Cluster, TG's , ALB and configure the code pipeline for deployment to ECS Fargate
- STAGE 5 : CLEANUP

![Architecture](catpipeline-arch-all.png)
