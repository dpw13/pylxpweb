    deviceData: MidboxDeviceData | None = None


# Parameter Control Models


class ParameterReadResponse(BaseModel):
    """Parameter read response.

    The API returns parameter keys directly in the response dict,
    not nested under a 'parameters' or 'valueFields' key.
    """

    success: bool
    inverterSn: str
    deviceType: int
    startRegister: int
    pointNumber: int
    valueFrame: str
    inverterRuntimeDeviceTime: str | None = None

    # Allow extra fields for all the parameter keys
    model_config = {"extra": "allow"}

    @property
    def serialNum(self) -> str:
        """Alias for inverterSn for backwards compatibility."""
        return self.inverterSn

    @property
    def parameters(self) -> dict[str, Any]:
        """Extract all parameter fields (excluding metadata fields)."""
        metadata_fields = {
            "success",
            "inverterSn",
            "deviceType",
            "startRegister",
            "pointNumber",
            "valueFrame",
            "inverterRuntimeDeviceTime",
        }
        return {k: v for k, v in self.model_dump().items() if k not in metadata_fields}


class QuickChargeStatus(BaseModel):
    """Quick charge/discharge status response.

    Note: The quickCharge/getStatusInfo endpoint returns status for BOTH
    quick charge and quick discharge operations.

    The newer firmware (minute-based Quick Charge) also reports the remaining
    time and task metadata. Older API versions omit these fields, so they
    default to safe values.
    """

    success: bool
    hasUnclosedQuickChargeTask: bool
    hasUnclosedQuickDischargeTask: bool = False  # May not be present in older API versions
    # Seconds remaining before quick charge stops (0 when idle/unknown).
    remainTimeBeforeQuickChargeStop: int = 0
    unclosedQuickChargeTaskId: int | None = None
