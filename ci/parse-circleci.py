import requests
import argparse


def get_jobs(base_url, access_token, limit, offset):
    url = base_url + "?token=" + access_token + "&limit=" + str(limit) + "&offset=" + str(offset)
    r = requests.get(url)
    return r.json()
    
def get_sha(build):
    return build['all_commit_details'][0]['commit'][:7], build['all_commit_details'][0]['commit_url']

def get_artifacts(base_url, access_token, build):
    url = base_url + '/'  + str(build['build_num']) + '/artifacts' + "?token=" + access_token
    r = requests.get(url)
    return r.json()


def find_artifact(artifacts, search_string):
    for artifact in artifacts:
        if search_string in artifact['url']:
            return artifact['url']
    return None

def _find_latest_successfull_build(json, branch):
    newer_build = None
    for build in json:
        if build['branch'] == branch:
            if not build['has_artifacts']:
                newer_build = build
            else:
                return build, True, newer_build
    return None, False, newer_build


def find_latest_successfull_build(base_url, access_token, branch):
    offset = 0
    limit = 100

    found = False
    while not found and offset<1000:
        json = get_jobs(base_url, access_token, limit, offset)
        build, found, newer_build = _find_latest_successfull_build(json, branch)
        offset += limit

    return build, found, newer_build


def main(url, access_token, branch, search_string):

    build, found, newer_build = find_latest_successfull_build(url, access_token, branch)
    
    if not found:
        print("Could not find any build on branch " + branch)
        return

    if newer_build is not None:
        sha_short, commit_url = get_sha(build)
        print('newer_build,', sha_short)

    artifacts = get_artifacts(url, access_token, build)
    artifact_url  = find_artifact(artifacts, search_string)

    if artifact_url is None:
        print("Could not find any artifact that contains the search string \"" + search_string + "\".")
        return

    sha_short, commit_url = get_sha(build)
    print('sha_short,', sha_short)
    print('commit_url,', commit_url)
    print('artifact_url,', artifact_url)
    

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get latest build artifacts for a specific branch')
    parser.add_argument('url', type=str, help='the base url for your circleci project')
    parser.add_argument('access_token', type=str, help='your personal access token for circleci')
    parser.add_argument('branch', type=str, help='the git branch that is searched for successfull builds')
    parser.add_argument('search_string', type=str, help='a string that must be included in the artifact')

    args = parser.parse_args()

    main(args.url, args.access_token, args.branch, args.search_string)

    