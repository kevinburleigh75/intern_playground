debug
## Targets

Figure out why RoleStack doesn't delete properly
- end goal:
  - we want stacks involving roles/groups/policies to properly delete
- initial target:
  - find the problem in this template [here]
  - If force deleting the original, bad template, there are "leftover" roles that are not deleted afterwards.
  - To delete the role itself, the policy "AllowDevsToAssumeEc2InstanceRolePolicy" must also be deleted first.
  - This ordering does not occur normally.
  - There is a dependency; adding the DependsOn Attribute to "AllowDevsToAssumeEc2InstanceRolePolicy" allows for flawless deleting.
  - As there is a data race situation, I tested deleting three instances of the deletion; all worked.
  - Updated template in github.
