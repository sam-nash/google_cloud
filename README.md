# Google Cloud

## Resource Organization

Google Cloud’s resource hierarchy contains four levels, and starting from the bottom up they are: resources, projects, folders, and an organization node.
At the first level are resources. These represent virtual machines, Cloud Storage buckets, tables in BigQuery, or anything else in Google Cloud.
Resources are organized into projects, which sit on the second level.
Projects can be organized into folders, or even subfolders.These sit at the third level.
And then at the top level is an organization node, which encompasses all the projects, folders, and resources in your organization.
It’s important to understand this resource hierarchy because it directly relates to how policies are managed and applied when you use Google Cloud.Policies can be defined at the project, folder, and organization node levels.Some Google Cloud services allow policies to be applied to individual resources, too.Policies are also inherited downward.This means that if you apply a policy to a folder, it will also apply to all of the projects within that folder.

Projects are the basis for enabling and using Google Cloud services, like managing APIs, enabling billing, adding and removing collaborators, and enabling other Google services.

Each project is a separate entity under the organization node, and each resource belongs to exactly one project.

Projects can have different owners and users because they’re billed and managed separately.

Each Google Cloud project has three identifying attributes: a project ID, a project name, and a project number.

The project ID is a globally unique identifier assigned by Google that can’t be changed after creation.

They’re what we refer to as being immutable.

Project IDs are used in different contexts to inform Google Cloud of the exact project to work with.

Project names, however, are user-created.

They don’t have to be unique and they can be changed at any time, so they are not immutable.

Google Cloud also assigns each project a unique project number.

It’s helpful to know that these Google-generated numbers exist, but we won’t explore them much in this course.

They’re mainly used internally by Google Cloud to keep track of resources.

Google Cloud’s Resource Manager tool is designed to programmatically help you manage projects.

It’s an API that can gather a list of all the projects associated with an account, create new projects, update existing projects, and delete projects.

It can even recover projects that were previously deleted, and can be accessed through the RPC API and the REST API.

The third level of the Google Cloud resource hierarchy is folders.

Folders let you assign policies to resources at a level of granularity that you choose.

The resources in a folder inherit policies and permissions assigned to that folder.

A folder can contain projects, other folders, or a combination of both.

You can use folders to group projects under an organization in a hierarchy.

For example, your organization might contain multiple departments, each with its own set Google Cloud resources.

Folders allow you to group these resources on a per-department basis.

Folders also give teams the ability to delegate administrative rights so that they can work independently.

As we mentioned earlier, the resources in a folder inherit policies and permissions from that folder.

For example, if you have two different projects that are administered by the same team, you can put policies into a common folder so they have the same permissions.

Doing it the other way--putting duplicate copies of those policies on both projects–could be tedious and error-prone.

If you needed to change permissions on both resources, you would have to do that in two places instead of just one.

To use folders, you must have an organization node, which is the very topmost resource in the Google Cloud hierarchy.

Everything else attached to that account goes under this node, which includes folders, projects, and other resources.

There are some special roles associated with this top-level organization node.

For example, you can designate an organization policy administrator so that only people with privilege can change policies.

You can also assign a project creator role, which is a great way to control who can create projects and, therefore, who can spend money.

How a new organization node is created depends on whether your company is also a Google Workspace customer.

If you have a Workspace domain, Google Cloud projects will automatically belong to your organization node.

Otherwise, you can use Cloud Identity, Google’s identity, access, application, and endpoint management platform, to generate one.

Once created, a new organization node will let anyone in the domain create projects and billing accounts, just as they could before.

You’ll also be able to create folders underneath it and put projects into it.

Both folders and projects are considered to be “children” of the organization node.

## IAM

When an organization node contains lots of folders, projects, and resources, a workforce might need to restrict who has access to what.

To help with this task, administrators can use Identity and Access Management, or IAM.

With IAM, administrators can apply policies that define who can do what and on which resources.

The “who” part of an IAM policy can be a Google account, a Google group, a service account, or a Cloud Identity domain.

A “who” is also called a “principal.”

Each principal has its own identifier, usually an email address.

The “can do what” part of an IAM policy is defined by a role.

An IAM role is a collection of permissions.

When you grant a role to a principal, you grant all the permissions that the role contains.

For example, to manage virtual machine instances in a project, you must be able to create, delete, start, stop and change virtual machines.

So these permissions are grouped into a role to make them easier to understand and easier to manage.

When a principal is given a role on a specific element of the resource hierarchy, the

resulting policy applies to both the chosen element and all the elements below it in the hierarchy.

You can define deny rules that prevent certain principals from using certain permissions, regardless of the roles they're granted.

This is because IAM always checks relevant deny policies before checking relevant allow policies.

Deny policies, like allow policies, are inherited through the resource hierarchy.

There are three kinds of roles in IAM: basic, predefined, and custom.

The first role type is basic.

Basic roles are quite broad in scope.

When applied to a Google Cloud project, they affect all resources in that project.

Basic roles include owner, editor, viewer, and billing administrator.

Let’s look at these basic roles in a bit more detail.

Project viewers can access resources but can’t make changes.

Project editors can access and make changes to a resource.

And project owners can also access and make changes to a resource.

In addition, project owners can manage the associated roles and permissions and set up billing.

Often companies want someone to control the billing for a project but not be able to change the resources in the project.

This is possible through a billing administrator role.

A word of caution: If several people are working together on a project that contains sensitive data, basic roles are probably too broad.

Fortunately, IAM provides other ways to assign permissions that are more specifically tailored to meet the needs of typical job roles.

This brings us to the second type of role, predefined roles.

Specific Google Cloud services offer sets of predefined roles, and they even define where those roles can be applied.

Let’s look at Compute Engine, for example, a Google Cloud product that offers virtual machines as a service.

With Compute Engine, you can apply specific predefined roles—such as “instanceAdmin”—to Compute Engine resources in a given project, a given folder, or an entire organization.

This then allows whoever has these roles to perform a specific set of predefined actions.

But what if you need to assign a role that has even more specific permissions?

That’s when you’d use a custom role.

Many companies use a “least-privilege” model in which each person in your organization is given the minimal amount of privilege needed to do their job.

So, for example, maybe you want to define an “instanceOperator” role to allow some users to stop and start Compute Engine virtual machines, but not reconfigure them.

Custom roles will allow you to define those exact permissions.

Before you start creating custom roles, please note two important details.

First, you’ll need to manage the permissions that define the custom role you’ve created.

Because of this, some organizations decide they’d rather use the predefined roles.

And second, custom roles can only be applied to either the project level or organization level.

They can’t be applied to the folder level.

## Service Accounts

What if you want to give permissions to a Compute Engine virtual machine, rather than to a person?

Well, that’s what service accounts are for.

Let’s say you have an application running in a virtual machine that needs to store data in Cloud

Storage, but you don’t want anyone on the internet to have access to that data–just that particular virtual machine.

You can create a service account to authenticate that VM to Cloud Storage.

Service accounts are named with an email address, but instead of passwords they use cryptographic keys to access resources.

So, if a service account has been granted Compute Engine’s Instance Admin role, this would allow

an application running in a VM with that service account to create, modify, and delete other VMs.

Service accounts do need to be managed.

For example, maybe Alice needs to manage which Google accounts can act as service accounts, while Bob just needs to be able to view a list of service accounts.

Fortunately, in addition to being an identity, a service account is also a resource, so it can have IAM policies of its own attached to it.

This means that Alice can have the editor role on a service account, and Bob can have the viewer role.

This is just like granting roles for any other Google Cloud resource.

## Cloud Identity

When new Google Cloud customers start using the platform, it’s common to log in to the Google Cloud

Console with a Gmail account and then use Google Groups to collaborate with teammates who are in similar roles.

Although this approach is easy to start with, it can present challenges later because the team’s identities are not centrally managed.

This can be problematic if, for example, someone leaves the organization.

With this setup, there’s no easy way to immediately remove a user’s access to the team’s cloud resources.

With a tool called Cloud Identity, organizations can define policies and manage their users and groups using the Google Admin Console.

Admins can log in and manage Google Cloud resources using the same usernames and passwords they already use in existing Active Directory or LDAP systems.

Using Cloud Identity also means that when someone leaves an organization, an administrator can use the Google Admin Console to disable their account and remove them from groups.

Cloud Identity is available in a free edition and also in a premium edition that provides capabilities to manage mobile devices.

If you’re a Google Cloud customer who is also a Google Workspace customer, this functionality is already available to you in the Google Admin Console.

# Interacting with Google Cloud

There are four ways to access and interact with Google Cloud.

The Cloud Console, the Cloud SDK and Cloud Shell, the APIs, and the Google Cloud App.

Let’s explore each of those now.

First is the Google Cloud Console, which is Google Cloud’s graphical user interface, or GUI, that helps you deploy, scale, and diagnose production issues in a simple web-based interface.

With the Cloud Console, you can easily find your resources, check their health, have full management control over them, and set budgets to control how much you spend on them.

The Cloud Console also provides a search facility to quickly find resources and connect to instances via SSH in the browser.

Second is through the Cloud SDK and Cloud Shell.

The Cloud SDK is a set of tools that you can use to manage resources and applications hosted on Google Cloud.

These include the Google Cloud CLI, which provides the main command-line interface for Google Cloud products and services, and bq, a command-line tool for BigQuery.

When installed, all of the tools within the Cloud SDK are located under the bin directory.

Cloud Shell provides command-line access to cloud resources directly from a browser.

Cloud Shell is a Debian-based virtual machine with a persistent 5 gigabyte home directory, which makes it easy to manage Google Cloud projects and resources.

With Cloud Shell, the Cloud SDK gcloud command and other utilities are always installed, available, up to date, and fully authenticated.

The third way to access Google Cloud is through application programming interfaces, or APIs.

The services that make up Google Cloud offer APIs so that code you write can control them.

The Cloud Console includes a tool called the Google APIs Explorer that shows which APIs are available, and in which versions.

You can try these APIs interactively, even those that require user authentication.

So, suppose you’ve explored an API, and you’re ready to build an application that uses it.

Do you have to start coding from scratch?

No.

Google provides Cloud Client libraries and Google API Client libraries in many popular languages to take

a lot of the drudgery out of the task of calling Google Cloud from your code.

Languages currently represented in these libraries are Java, Python, PHP, C#, Go, Node.js, Ruby, and C++.

And finally, the fourth way to access and interact with Google Cloud is with the Google Cloud app, which can

be used to start, stop, and use SSH to connect to Compute Engine instances and see logs from each instance.

It also lets you stop and start Cloud SQL instances.

Additionally, you can administer applications deployed on App Engine by viewing errors, rolling back deployments, and changing traffic splitting.

The Google Cloud app provides up-to-date billing information for your projects and billing alerts for projects that are going over budget.

You can set up customizable graphs showing key metrics such as CPU usage, network usage, requests per second, and server errors.

The app also offers alerts and incident management.

You can download the Google Cloud app at cloud.google.com/app.
