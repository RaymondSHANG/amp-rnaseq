import sys
import synapseclient

syn = synapseclient.login(silent=True)

files = syn.restGET('/entity/md5/%s' % sys.argv[1])
for item in files['results']:
	print sys.argv[1], item['name'], item['id'], item['versionNumber']
