# Releasing

Overall, the release process looks like this:

- Apply your changes.
- Update `appVersion` in [Chart.yaml](/Chart.yaml) if jitsi-helm is upgraded.
- Upgrade the version of HAProxy in [values.yaml](/values.yaml) if necessary.
- Test these changes on a test environment.
- Test again on an environment similar to the production environment.
- Update `version` in [Chart.yaml](/Chart.yaml).
- Create the package:
  ```bash
  # List keys
  gpg --list-keys --keyid-format LONG

  # Check the key on the key server.
  gpg --keyserver hkps://keys.openpgp.org --recv-keys "$KEY_ID"

  # Use your GPG signing identity
  helm package . -d ./docs/ --sign --key "$KEY_EMAIL" --keyring ~/.gnupg/secring.gpg
  ```
- Update the index:
  ```bash
  cd docs
  cp index.yaml /tmp/
  helm repo index . --url https://jitsi-contrib.github.io/jitsi-scaler/ --merge index.yaml
  ```
- Review the diff for [/docs/index.yaml](/docs/index.yaml). Sometimes Helm adds
  a new release to the index and also changes timestamps for **all** old
  releases as well. **Fix the corrupted timestamps by discarding those hunks
  from the staged changes.**
- Add the release files and index changes, commit and push:
  ```bash
  git add ...
  git commit -m 'Release Chart version vX.Y.Z'
  git push
  ```
- Create a release on GitHub. This step will also create a tag for the release.
