import dlt
from dagster import AssetExecutionContext
from dagster_embedded_elt.dlt import DagsterDltResource, dlt_assets
from wtt_sources import wtt_source
import os


@dlt_assets(
    dlt_source=wtt_source(),
    dlt_pipeline=dlt.pipeline(
        pipeline_name="wtt_events_pipeline",
        destination="filesystem",  # this uses S3-compatible interface when configured
        dataset_name="wtt_data"
    ),
    name="wtt_events",
    group_name="wtt",
)
def dagster_wtt_assets(context: AssetExecutionContext, dlt: DagsterDltResource):
    yield from dlt.run(context=context, loader_file_format="parquet")
