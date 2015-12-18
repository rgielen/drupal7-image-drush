FROM rgielen/httpd-image-drush:latest

ENV BASE_DIR /var
ENV DRUPAL_PROJECT_NAME drupal
ENV DRUPAL_DIR ${BASE_DIR}/${DRUPAL_PROJECT_NAME}

COPY scripts/fix-drupal-permissions.sh /usr/local/bin

# If existent, drush will use contrib subdir for managed modules
# See https://www.drupal.org/node/371298

RUN cd ${BASE_DIR} && drush dl drupal-7 --drupal-project-rename ${DRUPAL_PROJECT_NAME} \
    && cd ${DRUPAL_DIR} \
    && mkdir sites/all/modules/contrib && mkdir sites/all/modules/custom \
    && drush pm-download views \
    && groupadd -r drupal && useradd -r -g drupal drupal \
    && fix-drupal-permissions.sh --drupal_path=${DRUPAL_DIR} --drupal_user=drupal --httpd_group=www-data

VOLUME ${DRUPAL_DIR}/sites/all/modules/custom ${DRUPAL_DIR}/sites/all/themes ${DRUPAL_DIR}/sites/default/files
