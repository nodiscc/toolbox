#!/usr/bin/env python
from namecheap import Api

"""
Define variables regarding to your API account:
  - api_key
  - username
  - ip_address
"""
api_key = 'SECRET'
username = 'USERNAME'
ip_address = '1.2.3.4'

api = Api(username, api_key, username, ip_address, sandbox=True)
domain = "EXAMPLE.ORG"

#api.domains_create(
#    DomainName = 'lambdacore.network',
#    FirstName = 'Jack',
#    LastName = 'Trotter',
#    Address1 = 'Ridiculously Big Mansion, Yellow Brick Road',
#    City = 'Tokushima',
#    StateProvince = 'Tokushima',
#    PostalCode = '771-0144',
#    Country = 'Japan',
#    Phone = '+81.123123123',
#    EmailAddress = 'jack.trotter@example.com'
#)
# list domain records
api.domains_dns_getHosts(domain)
exit(1)

record = {
    # required
    "Type": "A",
    "Name": "test1",
    "Address": "127.0.0.2",

    # optional
    "TTL": "1800",
    "MXPref": "10"
}
# add A "test1" record pointing to 127.0.0.1
api.domains_dns_addHost(domain, record)

# delete record we just created,
# selecting it by Name, Type and Address values
#api.domains_dns_delHost(domain, record)
