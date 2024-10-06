# IAM

When an organization node contains lots of folders, projects, and resources, a workforce might need to restrict who has access to what.

To help with this task, administrators can use Identity and Access Management, or IAM.

IAM lets you grant granular access to specific Google Cloud resources and helps prevent access to other resources. IAM lets you adopt the security principle of least privilege, which states that nobody should have more permissions than they actually need.

With IAM, administrators can apply policies that define who can do what and on which resources.

This model for access management has three main parts:

The “who” part of an IAM policy called a **principal** represents an identity that can access a resource. Each principal has its own identifier, usually an email address.It can be a Google account, a Google group, a service account, or a Cloud Identity domain.

The “can do what” part of an IAM policy is defined by a **role**.

An IAM role is a collection of *permissions*.

Permissions determine what operations are allowed on a resource. In the IAM world, permissions are represented in the form of `service.resource.verb`, for example, `pubsub.subscriptions.consume`.

When you grant a role to a principal, you grant all the *permissions* that the role contains.

For example, to manage virtual machine instances in a project, you must be able to create, delete, start, stop and change virtual machines.

So these permissions are grouped into a role to make them easier to understand and easier to manage. [Reference](https://cloud.google.com/iam/docs/permissions-reference)

A **policy** is a collection of role bindings that bind one or more principals to individual roles. When you want to define who (principal) has what type of access (role) on a resource, you create an allow policy and attach it to the resource.

When a principal is given a role on a specific element of the resource hierarchy, the resulting policy applies to both the chosen element and all the elements below it in the hierarchy.

You can define deny rules that prevent certain principals from using certain permissions, regardless of the roles they're granted.

This is because IAM always checks relevant deny policies before checking relevant allow policies.

Deny policies, like allow policies, are inherited through the resource hierarchy.

There are three kinds of roles in IAM: **basic**, **predefined**, and **custom**.

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

When new Google Cloud customers start using the platform, it’s common to log in to the Google Cloud Console with a Gmail account and then use Google Groups to collaborate with teammates who are in similar roles.

Although this approach is easy to start with, it can present challenges later because the team’s identities are not centrally managed.

This can be problematic if, for example, someone leaves the organization.

With this setup, there’s no easy way to immediately remove a user’s access to the team’s cloud resources.

With a tool called Cloud Identity, organizations can define policies and manage their users and groups using the Google Admin Console.

Admins can log in and manage Google Cloud resources using the same usernames and passwords they already use in existing Active Directory or LDAP systems.

Using Cloud Identity also means that when someone leaves an organization, an administrator can use the Google Admin Console to disable their account and remove them from groups.

Cloud Identity is available in a free edition and also in a premium edition that provides capabilities to manage mobile devices.

If you’re a Google Cloud customer who is also a Google Workspace customer, this functionality is already available to you in the Google Admin Console.
