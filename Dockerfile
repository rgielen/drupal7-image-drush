FROM rgielen/httpd-image-drush:latest

ENV BASE_DIR /var
ENV DRUPAL_PROJECT_NAME drupal
ENV DRUPAL_DIR ${BASE_DIR}/${DRUPAL_PROJECT_NAME}

RUN cd ${BASE_DIR} && drush dl drupal-7 --drupal-project-rename ${DRUPAL_PROJECT_NAME} \
    && cd ${DRUPAL_DIR} \
    && mkdir sites/all/modules/contrib && mkdir sites/all/modules/custom \
    && drush pm-download views \
    && chown -R root:www-data ${DRUPAL_DIR}

VOLUME ${DRUPAL_DIR}/sites/all/modules/custom ${DRUPAL_DIR}/sites/all/themes ${DRUPAL_DIR}/sites/default/files
